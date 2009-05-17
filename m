Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbZEQBsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbZEQBsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZEQBsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:48:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:32510 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZEQBsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jXeLzzya/bR2aQB/zUXPDAPd1f2H/soSuWsDimEw3mNgAMTEOe2tTyzwGJABAF7U/H
         mtDfdP9hPAwkHt77MKDVS1YFFNvKGXaywTine+ZZsSCqbxrzW9+/SechfJYoSVdMSXOH
         JJKsCRbc1ZmO2PpH2MDcP6i3rjYNWRaZWGHNs=
MIME-Version: 1.0
In-Reply-To: <20090516161419.62c45c2b.akpm@linux-foundation.org>
References: <20090514094951.36fd7333@bike.lwn.net>
	 <20090516161419.62c45c2b.akpm@linux-foundation.org>
Date: Sun, 17 May 2009 09:48:37 +0800
Message-ID: <d82e647a0905161848y25ef1480id4f1914b065c6528@mail.gmail.com>
Subject: Re: 2.6.30-rc kills my box hard - and lockdep chains
From: Ming Lei <tom.leiming@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/17 Andrew Morton <akpm@linux-foundation.org>:
> It is a deep stack trace.
>
> And unfortunately
>
> a) that diagnostic didn't print the stack pointer value, from which
>   we can often work out if we're looking at a stack overflow.
>
> b) I regularly think it would be useful if that stack backtrace were
>   to print out the actual stack address, so we could see how much
>   stack each function is using.

I have the same sense, because lockdep uses many recursion function ,which
may cause stack overflow easily.

>
>   I just went in to hack these things up, but the x86 stacktrace
>   code which I used to understand has become stupidly complex so I
>   gave up.
>
> What tools do we have to diagnose a possible kernel stack overflow?
> There's CONFIG_DEBUG_STACK_USAGE but that's unlikely to be much use.

-- 
Lei Ming
