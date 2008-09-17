Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYIQHLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYIQHLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 03:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYIQHKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 03:10:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:23335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYIQHKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 03:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=f3ove76+NC5t43RYsrI4DYb8d3qUacy3PaTRefeSY1p7Ri2U2HTts6uwWez74bhdA0
         CmS/Sxjyh+3OJn1SfLj8DJQtx7vWSQjcqRgR8H5QrrO8QVe+qvHaYkbO5+UhM+B9Ow1S
         OHDNBr1DO3NuL22Buxiw3dGidKpggImwFbT+k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Date: Wed, 17 Sep 2008 00:10:09 -0700
Message-Id: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    KERN_PCI
    KERN_ACPI
v4: fix some checkpatch error and warning
v5: add default with DEFINE_LOGLEVE_SETUP_DEF
    KERN_APIC

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
