Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbXEIU0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbXEIU0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXEIUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:25:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:7080 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbXEIUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:25:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=SpDt1XP2oJKRR0l2I6ZX9gU7J+7PZHQkPWxqg+3WVqbEMeyqggA2Yiqan19v0C204
	9EoVb3wri6HVQ7mjhf5Yw==
Date: Wed, 9 May 2007 13:25:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
In-Reply-To: <20070509212313.7d61f113@the-village.bc.nu>
Message-ID: <alpine.DEB.0.99.0705091321470.26189@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
 <20070508163452.8b71f682.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
 <20070508190800.1334b968.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081934390.20751@chino.kir.corp.google.com>
 <20070509102134.5d722386@the-village.bc.nu>
 <alpine.DEB.0.99.0705090308150.17598@chino.kir.corp.google.com>
 <20070509143621.282f2400@the-village.bc.nu>
 <alpine.DEB.0.99.0705091137310.22593@chino.kir.corp.google.com>
 <20070509212313.7d61f113@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Alan Cox wrote:

> arch/foo almost always supports a single compiler too - gcc. We simply
> don't support anything else. We use gcc inlines and features extensively.
> 

Ok, so your "acceptable use clause" of your addition should include that 
fact.  That the volatile type qualifier is legitimate when developing a 
new architecture and the only implementation you support for compilation 
of such text has a one-to-one correspondence between actual and abstract 
machine semantics.

> [1] ANSI C says access to the padding fields of a struct is undefined.
> ANSI C also says that struct assignment is a memcpy. Therefore struct
> assignment in ANSI C is a violation of ANSI C...
> 

Padding bytes are unspecified, not undefined.  I doubt ANSI C says 
padding bytes are undefined because then any implementation that pads 
members of a struct object would not be strictly conforming.

		David
