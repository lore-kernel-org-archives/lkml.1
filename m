Return-Path: <linux-kernel-owner+w=401wt.eu-S969711AbXEICjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969711AbXEICjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934410AbXEICjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:39:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934400AbXEICjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:39:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=M1P4IZLpnSFkD77/ilyjeRA3SXkaTYaLAT0aO2TyXek89J2PvZ/iSCZ6aEYlD0WdA
	Rk4KFhTkeoCOtQdgjKqTg==
Date: Tue, 8 May 2007 19:38:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
In-Reply-To: <20070508190800.1334b968.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.0.99.0705081934390.20751@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
 <20070508163452.8b71f682.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
 <20070508190800.1334b968.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Randy Dunlap wrote:

> "volatile" used on a gcc asm extension is different, granted.
> It's not even a C-language "volatile" keyword AFAICT, so it doesn't
> apply in this context.
> 

Using 'volatile' for an asm construct certainly is a keyword; in fact, C99 
defines 'volatile' as a token which is reserved for use as a keyword.

> Anyway, how is this slightly modified title?
> 
> +***** "volatile" considered useless and evil:  Just Say NO! *****
> +
> +Do not use the C-language "volatile" keyword on kernel data
> +(extracted from lkml emails from Linus)
> 

It's still ambiguous.  A much more explicit title that nobody could argue 
with would be "do not use the 'volatile' keyword as a type qualifier for 
an object."

		David
