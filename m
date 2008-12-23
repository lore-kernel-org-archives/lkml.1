Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYLWAMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYLWAMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYLWAMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:23 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59362 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYLWAMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:12:22 -0500
From: paulmck@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       ralf@linux-mips.org, kernel@wantstofly.org, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: [PATCH -tip] Change default from CLASSIC_RCU to TREE_RCU (testing only)
Date: Mon, 22 Dec 2008 16:12:15 -0800
Message-Id: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset changes the default RCU implementation from CONFIG_CLASSIC_RCU
to CONFIG_TREE_RCU.  This affects kernel/Kconfig.preempt as well as a large
number of the arch-specific defconfig files.
