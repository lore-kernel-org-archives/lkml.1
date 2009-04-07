Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbZDGPJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbZDGPJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbZDGPHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48824 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbZDGPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:41 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [0/28] x86: MCE: Feature series for 2.6.31
Date: Tue,  7 Apr 2009 17:07:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various new Intel x86 machine check features, including initial support
for machine check recovery and new status bits. The actual machine check
recovery requires some generic VM changes, which will be posted in a separate
series ("POISON series") This series can be applied without the POISON
series and POISON requires these patches.

Especially the broadcast and early nowayout patches are fairly important for 
Nehalem CPUs, without them machine checks are often incorrectly reported
due to the shared bank topology of the system.

-Andi
