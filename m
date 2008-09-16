Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYIPSCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYIPSCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYIPSCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:02:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:11320 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbYIPSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UHxS7E9D9aAdFx2q1ZTVWJ50HxZwSPS/UP2TlWrEYKoSBVRGsXiqfo8ygebJBVDHgW
         h+vhEzGoJWJnNqr/uuM3l+MlYAT/iUoHoG2mFAf4UoKPiwCk3Ej1AK82vwSVPpoXjWHO
         +XN+125HERFPcqZ6p2CiLrZZl8dOfQ4uALOzc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 0/5] loglevel=pci:7,acpi:6 support
Date: Tue, 16 Sep 2008 11:01:20 -0700
Message-Id: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usage:
	in .c to have
		DEFINE_LOGLEVEL_SETUP(pci, "pci:");
	in .h to have
		DECLARE_LOGLEVE(pci);
	then could use
		pci_printk(KERN_LOG_DEBUG, fmt, ...);
	and command line
		loglevel=pci:7

you can add different printk to different files of one subsys if you like
not just one susbsys one tag, and don't need to update kernel.h to add more tags

YH

