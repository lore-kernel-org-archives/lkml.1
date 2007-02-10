Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbXBKCuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbXBKCuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 21:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXBKCuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 21:50:51 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:59931 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXBKCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 21:50:51 -0500
Date: Sat, 10 Feb 2007 21:05:57 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-mips@linux-mips.org,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <ak@suse.de>
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070210210557.GA9116@linux-mips.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <1171058342.29713.136.camel@pmac.infradead.org> <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com> <20070210102205.GB8145@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210102205.GB8145@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 11:22:05AM +0100, Heiko Carstens wrote:

> Which remembers me that I think that MIPS is using the non-compat version
> of sys_epoll_pwait for compat syscalls. But maybe MIPS doesn't need a compat
> syscall for some reason. Dunno.

Which reminds me that x86_64 i386 compat doesn't wire up sys_epoll_pwait ;-)

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/arch/x86_64/ia32/ia32entry.S b/arch/x86_64/ia32/ia32entry.S
index b4aa875..5993262 100644
--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -718,4 +718,5 @@ ia32_sys_call_table:
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
+	.quad sys_epoll_pwait
 ia32_syscall_end:		
