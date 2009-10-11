Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbZJKRfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbZJKRfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbZJKRfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:35:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317AbZJKRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:35:08 -0400
Date: Sun, 11 Oct 2009 10:34:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeff Chua <jeff.chua.linux@gmail.com>, Valdis.Kletnieks@vt.edu,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: <1255251993.2192.36.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0910111033160.3438@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>  <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>  <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>  <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain> 
 <b6a2187b0910052312o662642b2teded3d19548b9151@mail.gmail.com>  <alpine.LFD.2.01.0910060731190.3432@localhost.localdomain> <1255251993.2192.36.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Oct 2009, Benjamin Herrenschmidt wrote:
> > 
> > It's supposed to be easier these days, but I guess distros don't compile 
> > in support for 64-bit mode by default. Just using another machine may be 
> > the simplest approach, if you have any 64-bit distro around.
> 
> My experience is that most distros have a compiler capable of generating
> a 64-bits kernel

At least not Fedora x86. Doing "gcc -m64" results in

	sorry, unimplemented: 64-bit mode not compiled in

on my laptop.

			Linus
