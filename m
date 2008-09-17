Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYIQI2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYIQI2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYIQI2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:28:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:15916 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYIQI2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SkN88xujCDyRCJsoWhL9TwWQ2qBywKTHDhDKBkmqnjD+BQkaJE9c4+1Ls5Kh2yZXLB
         LLAMkE4f8Lr5f4JzeBQWArp+lKnm7la/vcXac0yY1XDMh3PWcPe1yaKvmEFeAZtmS6Px
         ok611TgCSnfmDSgZDpsCfUgIhikDffsQ2Qa/Y=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Date: Wed, 17 Sep 2008 01:27:41 -0700
Message-Id: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    KERN_PCI
    KERN_ACPI
v4: fix some checkpatch error and warning
v5: add default with DEFINE_LOGLEVE_SETUP_DEF
    KERN_APIC
v6: set the default only one time

usage:
	in .h to have
		#define KERN_PCI "<pci>"
	in .c to have
		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
	then could use
		printk(KERN_DEBUG KERN_PCI fmt, ...);
	and command line
		loglevel=3,pci:8

you can add different printk to different files of one subsys if you like
not just one susbsys one tag, and don't need to update kernel.h to add more tags

YH
