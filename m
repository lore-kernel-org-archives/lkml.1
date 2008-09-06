Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYIFBHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYIFBHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 21:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYIFBFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 21:05:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:27220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbYIFBFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 21:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,343,1217833200"; 
   d="scan'208";a="436263624"
Message-Id: <20080906010214.229910000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Sep 2008 18:02:14 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: [RFC 0/4] Using HPET in MSI mode and setting up per CPU HPET timers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patchset that uses HPET timers in MSI mode (when supported) and sets up per
CPU HPET timers. This removes the dependency on IRQ0 timer broadcast with LAPIC
stopping in deep C-state, on platforms that support HPET MSI mode.

On my test system with dual core CPU, the number of timer related interrupts
(HPET_MSI + IRQ0 + LAPIC) comes down from 180 to 95 over a period of 10s,
with these patches.
This is on an idle system with tickless enabled and when system is idle.

Patches against tip.

-- 

