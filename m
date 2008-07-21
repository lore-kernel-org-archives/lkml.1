Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbYGUFVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbYGUFVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbYGUFUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:20:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575AbYGUFUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:20:47 -0400
Subject: Re: [PATCH 9/22] ia64: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080721001909.GA24246@parisc-linux.org>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <1216596106.3679.98.camel@jaswinder.satnam>
	 <1216596325.3679.104.camel@jaswinder.satnam>
	 <1216596669.3679.112.camel@jaswinder.satnam>
	 <1216596749.3679.115.camel@jaswinder.satnam>
	 <1216596835.3679.117.camel@jaswinder.satnam>
	 <20080721001909.GA24246@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 10:49:44 +0530
Message-Id: <1216617584.2705.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matthew,

On Sun, 2008-07-20 at 18:19 -0600, Matthew Wilcox wrote:
> On Mon, Jul 21, 2008 at 05:03:55AM +0530, Jaswinder Singh wrote:
> > Declaring arch-dependent syscalls for ia64 architecture
> > +#ifndef CONFIG_PCI
> > +asmlinkage long sys_pciconfig_read(unsigned long, unsigned long,
> > +				   unsigned long, unsigned long, void *);
> > +asmlinkage long sys_pciconfig_write(unsigned long, unsigned long,
> > +				    unsigned long, unsigned long, void *);
> > +#endif /* CONFIG_PCI */
> 
> These are already declared in linux/syscalls.h
> 
> And frankly, we should just make these return -ENOSYS always.  Any
> software that uses them is stuffed on machines with multiple domains.
> 

diff --git a/include/asm-ia64/syscalls.h b/include/asm-ia64/syscalls.h
index 71af530..8799e14 100644
--- a/include/asm-ia64/syscalls.h
+++ b/include/asm-ia64/syscalls.h
@@ -28,11 +28,5 @@ asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
 				   int, int, int, long);
 asmlinkage unsigned long sys_mmap(unsigned long, unsigned long,
 				  int, int, int, long);
-#ifndef CONFIG_PCI
-asmlinkage long sys_pciconfig_read(unsigned long, unsigned long,
-				   unsigned long, unsigned long, void *);
-asmlinkage long sys_pciconfig_write(unsigned long, unsigned long,
-				    unsigned long, unsigned long, void *);
-#endif /* CONFIG_PCI */
 
 #endif /* _ASM_IA64_SYSCALLS_H */

Thank you,

Jaswinder Singh.

