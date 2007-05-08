Return-Path: <linux-kernel-owner+w=401wt.eu-S967196AbXEHLSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967196AbXEHLSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934230AbXEHLSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:18:08 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4161 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144AbXEHLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:18:07 -0400
Date: Tue, 8 May 2007 12:17:59 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Bogus section mismatch errors?
Message-ID: <20070508111759.GA26562@flint.arm.linux.org.uk>
Mail-Followup-To: Linux Kernel List <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


WARNING: arch/arm/mach-realview/built-in.o - Section mismatch:
 reference to .init.text: from .data between 'realview_timer' (at offset 0x54)
 and 'clcd_plat_data'

Weird, these two data structures don't interact with each other.  Probably
bogus.

WARNING: init/built-in.o - Section mismatch:
 reference to .init.text: from .text between 'rest_init' (at offset 0x2c)
 and 'run_init_process'
WARNING: mm/built-in.o - Section mismatch:
 reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x1bd94)
 and 'cache_reap'
WARNING: mm/built-in.o - Section mismatch:
 reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x1bdcc)
 and 'cache_reap'

Are these more bogus?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
