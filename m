Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbZJKJLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbZJKJLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZJKJLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:11:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:35533 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbZJKJLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:11:06 -0400
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Valdis.Kletnieks@vt.edu,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <alpine.LFD.2.01.0910060722060.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
	 <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>
	 <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>
	 <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
	 <1254833974.14541.1306.camel@macbook.infradead.org>
	 <alpine.LFD.2.01.0910060722060.3432@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 20:08:53 +1100
Message-Id: <1255252133.2192.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 07:26 -0700, Linus Torvalds wrote:

> The Intel Xorg guys used to do everything in 32-bit kernels because they 
> were also testing that they didn't break compatibility (which is a big 
> deal with that whole crazy DRM-in-kernel/direct-rendering-in-user-space 
> thing) and seemingly didn't realize that the compat layer was _supposed_ 
> to mean that they could run a 64-bit kernel and still have a working 
> 32-bit land.
> 
> It's driver interfaces like that that tend to break. ioctl's etc. But I 
> have heard less noise about it lately, so I do think it's mostly working.

I'm running a 32-bit Ubuntu karmic distro with a 64-bit kernel on my
thinkpad and so far, I yet have to encounter a single obvious problem
due to the compat layer. Everything seems to work fine including 3D,
compiz fancyness in X etc... :-)

Cheers,
Ben.



