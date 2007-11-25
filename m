Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbXKYX3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbXKYX3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 18:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXKYX3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 18:29:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33365 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbXKYX3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 18:29:15 -0500
Date: Sun, 25 Nov 2007 15:17:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mathias Kretschmer <posting@blx4.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 (gentoo + grsec) kernel BUG at mm/mlock.c:205!
Message-ID: <20071125151731.0060872d@laptopd505.fenrus.org>
In-Reply-To: <4749CEA4.9070406@blx4.net>
References: <4749CEA4.9070406@blx4.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 20:36:04 +0100
Mathias Kretschmer <posting@blx4.net> wrote:

> Hi,
> 
> this is a x86_64 kernel with 4GB of RAM. incident happened when
> compiling cdrecord (or some variant of it :) in a 32-bit chroot jail
> during the 'configure' process.
> 
> alpha / # uname -a
> Linux alpha 2.6.22-hardened-r8 #10 SMP Sun Nov 25 12:52:39 CET 2007
> x86_64 AMD Processor model unknown AuthenticAMD GNU/Linux
> 
> Let me know, if you need for info.
> 

you have both a heavily patched kernel and a tainted kernel due to
binary kernel modules.... sounds like you're best of contacting the
support side of whoever gave you the patches and/or the binary module;
I don't think there's much lkml can do for you.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
