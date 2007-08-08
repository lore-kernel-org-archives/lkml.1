Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbXHHQPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbXHHQPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763118AbXHHQPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:15:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49090 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762740AbXHHQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:15:22 -0400
Date: Wed, 8 Aug 2007 18:15:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: [rfc] Re: [PATCH] Make UIO available for arm architecture
In-Reply-To: <200708081808.13889.hjk@linutronix.de>
Message-ID: <Pine.LNX.4.64.0708081812250.3715@fbirervta.pbzchgretzou.qr>
References: <200708081808.13889.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-261557662-1186589721=:3715"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-261557662-1186589721=:3715
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 8 2007 18:08, Hans-Jürgen Koch wrote:
>---
>Index: linux-2.6.23-rc/arch/arm/Kconfig
>===================================================================
>--- linux-2.6.23-rc.orig/arch/arm/Kconfig	2007-08-08 17:52:02.000000000 +0200
>+++ linux-2.6.23-rc/arch/arm/Kconfig	2007-08-08 17:53:29.000000000 +0200
>@@ -1052,6 +1052,8 @@
> 
> source "drivers/dma/Kconfig"
> 
>+source "drivers/uio/Kconfig"
>+
> endmenu
> 
> source "fs/Kconfig"

I am raising a general question here.
Should not such cross-platform things be made available in a general
Kconfig rather than having to patch each arch's Kconfig?

I am thinking of drivers/Kconfig for this one (of course I am aware that this
requires an extra "depends on X86 || SPARC || others" in drivers/pci/Kconfig),
and perhaps even a top-level Kconfig for things like truly arch-independent
fs/Kconfig.


	Jan
-- 
---699020219-261557662-1186589721=:3715--
