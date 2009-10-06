Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbZJFO20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbZJFO20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932755AbZJFO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:28:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932714AbZJFO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:28:23 -0400
Date: Tue, 6 Oct 2009 07:26:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
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
In-Reply-To: <1254833974.14541.1306.camel@macbook.infradead.org>
Message-ID: <alpine.LFD.2.01.0910060722060.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>  <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>  <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>  <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
 <1254833974.14541.1306.camel@macbook.infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, David Woodhouse wrote:

> On Mon, 2009-10-05 at 17:30 -0700, Linus Torvalds wrote:
> > In fact, I wish more people did that, just so that we'd get better 
> > coverage of the 32-bit compat code. We occasionally find issues there,
> > although I think it's getting rarer.
> 
> We've been running PPC64 with 32-bit userspace for a long time, so most
> of the issues with the 32-bit compat code ought to be dealt with.
> 
> There may be a few arch-specific issues for x86_64/i386, but not many.

The Intel Xorg guys used to do everything in 32-bit kernels because they 
were also testing that they didn't break compatibility (which is a big 
deal with that whole crazy DRM-in-kernel/direct-rendering-in-user-space 
thing) and seemingly didn't realize that the compat layer was _supposed_ 
to mean that they could run a 64-bit kernel and still have a working 
32-bit land.

It's driver interfaces like that that tend to break. ioctl's etc. But I 
have heard less noise about it lately, so I do think it's mostly working.

		Linus
