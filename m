Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZFTUGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZFTUGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZFTUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:06:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35975 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZFTUGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:06:12 -0400
Date: Sat, 20 Jun 2009 22:06:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Double-switching SMP alternatives
Message-ID: <alpine.LSU.2.00.0906202205150.29073@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


in dmesg of a 2.6.25, I am finding:

Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
[...]
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 4000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5581.16 BogoMIPS 
(lpj=2790583)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.80GHz stepping 07
Booting processor 2/6 ip 4000
Initializing CPU#2
[...]


Would not it make sense to skip the first switch to UP?


