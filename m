Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYIQBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYIQBO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 21:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYIQBOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 21:14:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26778 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYIQBOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 21:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hVTtZPB04G93KwvW9R0X68QtE7T8okAqagrlWXCpFwIK+8JJtVlZPnROQnnQW8DqgC
         lWXAOdRGskyhNQHZaoBy4CzfM98cdY78AMQeNCUchSsKLuFSO+Cy7l2QtDD3Fa/tYqfs
         lgTYIOoyp0/xgQag111hbIkKScARQIdckuN3k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/5] loglevel=pci:8,acpi:8 support v4
Date: Tue, 16 Sep 2008 18:14:08 -0700
Message-Id: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4: fix some checkpatch error and warning

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
