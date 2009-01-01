Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZAAVOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZAAVOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 16:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZAAVO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 16:14:26 -0500
Received: from smtp.tal.de ([81.92.1.5]:50996 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZAAVO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 16:14:26 -0500
From: ib@wupperonline.de (Ingo Brueckl)
Date: Thu, 01 Jan 2009 22:13:00 +0100
Subject: compile time warnings
X-Mailer: blueMail 1.4 (SlipDoor 2.2)
Message-ID: <495d3100@wupperonline.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe somebody noticed already, with kernel 2.6.28 and gcc 4.3.2 there are a
few compile time warnings:

  arch/x86/kernel/setup.c:742: warning: 'dmi_low_memory_corruption' defined but not used

  arch/x86/mm/init_32.c: In function 'pagetable_init':
  arch/x86/mm/init_32.c:515: warning: unused variable 'pgd_base'

  drivers/acpi/tables/tbfadt.c: In function 'acpi_tb_create_local_fadt':
  /usr/src/linux/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds

  drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':
  /usr/src/linux/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds

  WARNING: modpost: Found 1 section mismatch(es).
  To see full details build your kernel with:
  'make CONFIG_DEBUG_SECTION_MISMATCH=y'
