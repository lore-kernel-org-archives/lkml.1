Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYIPXOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYIPXOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYIPXOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:14:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:39969 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYIPXOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hSpiAnEe9ERP2Ri9yAVEbE8XHJExsYMxSd/DoiMzlKmpN4P8VqLXVF8s/e7+85GtUa
         ZCiKSY8UBT4U2wuBPPQ99oM8SCDn95ZTTvrX5MNcFsJ/vfIDLqXgjfNFeLLA5T0cltYi
         LE76QHiOOlPR+qT19Y9U8gtqOCgpEGSlslYzo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/5] loglevel=pci:7,acpi:6 support v3
Date: Tue, 16 Sep 2008 16:13:53 -0700
Message-Id: <1221606838-30246-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usage:
	in .h to have
		#define KERN_PCI "<pci>"
	in .c to have
		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
	then could use
		printk(KERN_DEBUG KERN_PCI fmt, ...);
	and command line
		loglevel=pci:8

you can add different printk to different files of one subsys if you like
not just one susbsys one tag, and don't need to update kernel.h to add more tags

YH

