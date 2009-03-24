Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZCXAUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZCXAUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 20:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZCXATt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 20:19:49 -0400
Received: from mx40.brocade.com ([144.49.195.4]:12255 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZCXATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 20:19:48 -0400
X-IronPort-AV: E=Sophos;i="4.38,410,1233561600"; 
   d="scan'208";a="58366893"
Date: Mon, 23 Mar 2009 17:10:09 -0700
From: Krishna Gudipati <kgudipat@brocade.com>
Message-Id: <200903240010.n2O0A9vp013492@blc-10-2.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This is the an interim submission of Brocade BFA FC SCSI Driver for code review.
We moved FC protocol/port state machine part of the driver to the firmware to
make the driver simpler. We also implemented the code review comments received
from last submission which includes: 1) replaced bfa specific list management
routines by standard linux list implemetation. 2) Other minor fixes to naming,
Makefile, kconfig etc.

Please note that this driver is still not fully functioning. We expect to do
anoher submssion next week after we complete all the changes.

It contains a serial of 5 patches generated using 2.6.29-rc8 kernel. Here is
a brief description of each patch:

[PATCH 1/5]: Linux driver specific code, things such as module load/unload,
PCI probe/release, interrupt handler, and sysfs interface etc. All the files
start with "bfad_" prefix.

[PATCH 2/5]: Hardware/FW access code. All files start with "bfa_" prefix.

[PATCH 3/5]: Common header files shared by linux driver specific and
hardware/FW access code.

[PATCH 4/5]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver.

[PATCH 5/5]: Updated MAINTAINER file.

Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
---
