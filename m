Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZJKJHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZJKJHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZJKJHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:07:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:35512 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbZJKJHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:07:46 -0400
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Valdis.Kletnieks@vt.edu,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <alpine.LFD.2.01.0910060731190.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
	 <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>
	 <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>
	 <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
	 <b6a2187b0910052312o662642b2teded3d19548b9151@mail.gmail.com>
	 <alpine.LFD.2.01.0910060731190.3432@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 20:06:33 +1100
Message-Id: <1255251993.2192.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 07:35 -0700, Linus Torvalds wrote:
> 
> On Tue, 6 Oct 2009, Jeff Chua wrote:
> > 
> > First, have to compile gcc so that it can compile 64 bit kernel. That's a
> > tough one!
> 
> It's supposed to be easier these days, but I guess distros don't compile 
> in support for 64-bit mode by default. Just using another machine may be 
> the simplest approach, if you have any 64-bit distro around.

My experience is that most distros have a compiler capable of generating
a 64-bits kernel, if not 64-bits userspace (the later depends on whether
the "other" bits such as libgcc, glibc, etc... are there for 64-bits,
which is also generally available, though optional).

I regulary compile 64-bit kernels with a 32-bit Ubuntu or Debian on i386

Cheers,
Ben.

