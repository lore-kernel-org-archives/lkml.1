Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbXGFM3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbXGFM3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759995AbXGFM3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:29:00 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59223 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759970AbXGFM3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:29:00 -0400
Message-ID: <468E3579.1020109@s5r6.in-berlin.de>
Date: Fri, 06 Jul 2007 14:28:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead(?) i386-related CONFIG variables
References: <Pine.LNX.4.64.0707050726110.12036@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707050726110.12036@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/2007 1:27 PM, Robert P. J. Day wrote:
>   since it's not clear who a single contact person would be for
> i386-related stuff like this, here's what my script turned up for
> tests on non-existent CONFIG variables under arch/i386:
> 
> ========== BALANCED_IRQ_DEBUG ==========
> arch/i386/kernel/io_apic.c:356:#ifdef CONFIG_BALANCED_IRQ_DEBUG

-#ifdef CONFIG_BALANCED_IRQ_DEBUG
+#if 0 /* debug IRQ balancing */

> ========== DEBUG_PAGE_TYPE ==========
> arch/i386/kernel/vmi.c:238:#ifdef CONFIG_DEBUG_PAGE_TYPE

-#ifdef CONFIG_DEBUG_PAGE_TYPE
+#if 0 /* debug page type */

arch/i386/kernel/vmi.c:339

-#endif
+#endif /* debug page type */

> ========== SERIAL_DETECT_IRQ ==========
> arch/i386/kernel/legacy_serial.c:18:#ifdef CONFIG_SERIAL_DETECT_IRQ

Hmm, not sure about this.  The code section was taken from
include/asm-{i386,x86_64}/serial.h.  This is an option similar to other
CONFIG_SERIAL_ options in numerous places.

Serial drivers are orphaned, aren't they?

>   feel free to take this as seriously as you want.  :-)
> 
> rday

-- 
Stefan Richter
-=====-=-=== -=== --==-
http://arcgraph.de/sr/
