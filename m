Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYIRATV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYIRATV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 20:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYIRATH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 20:19:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:43250 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYIRATG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 20:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y9TKwYs2fHARSOhemgZZ5y9OWjYRIKIMRStoO/ZIU6wegzWW1+ictZj0ebBVpTQAmP
         xwbENBEL1tI0+fXx+vP3QZSJ5dEfcR5zPqwmbBvO1YMeqtAYcPOzRl2K9n+S7sx5tzLa
         KPaZZ+r4r874939PEnPOpat703sxEPKk9M7GI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/7] loglevel=pci:8,acpi:8,apic=12,dev:8 support v7
Date: Wed, 17 Sep 2008 17:18:24 -0700
Message-Id: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
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
v7: expand msg_loglevel to 2 digi bits. so KERN_APIC could start from 10

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
