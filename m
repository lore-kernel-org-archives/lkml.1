Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYBQE3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYBQE3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYBQE2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:28:53 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26737 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYBQE2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:28:52 -0500
Date: Sat, 16 Feb 2008 20:27:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What is
 "ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!"
Message-Id: <20080216202740.74e22dbb.randy.dunlap@oracle.com>
In-Reply-To: <47B786BF.8050703@gmail.com>
References: <47B786BF.8050703@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 08:58:39 +0800 Peter Teoh wrote:

> Can some explain the cause of this error (it has been like this for the 
> last two git pull from linus tree):
> 
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 1589 modules
> ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_regs" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_idt_desc" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_guest_gdt" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_sp" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_regs_trapnum" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_guest_idt_desc" [drivers/lguest/lg.ko] undefined!
> WARNING: modpost: Found 14 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Please try the patch at
http://marc.info/?l=linux-kernel&m=120206956919303&w=2
and report on its success/failure.  Thanks.

---
~Randy
