Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXEISqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXEISqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbXEISqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:46:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbXEISqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:46:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=wJGAL8ZjVPKFIOSNoY5QyVjXwkoyI3Xj1FnNBK0s7Sl3c/9UHDKRhyTkHK6+CfC7f
	ousSk7uV3HyzilC0XS7PQ==
Date: Wed, 9 May 2007 11:41:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
In-Reply-To: <20070509143621.282f2400@the-village.bc.nu>
Message-ID: <alpine.DEB.0.99.0705091137310.22593@chino.kir.corp.google.com>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Alan Cox wrote:

> > Thus, any reliance on type-qualifying an object that represents an atomic 
> > or locking primitive on the keyword 'volatile' is misplaced.
> 
> arch/foo is generally implementation specific code.
> 

That's true, but what qualifies as an "access" to an object that is 
type qualified with the 'volatile' keyword is _implementation_ defined, 
meaning the behavior is defined by the compiler and not this new 
architecture you're proposing 'volatile' is appropriate for.  That's pure 
C99.
