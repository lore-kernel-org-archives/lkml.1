Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZDBDcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZDBDcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZDBDcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:32:07 -0400
Received: from mx30.brocade.com ([144.49.194.4]:19488 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZDBDcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:32:06 -0400
X-IronPort-AV: E=Sophos;i="4.39,310,1235980800"; 
   d="scan'208";a="71935943"
Date: Wed, 1 Apr 2009 20:32:02 -0700
From: Krishna Gudipati <kgudipat@brocade.com>
Message-Id: <200904020332.n323W2Yq003386@blc-10-2.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, nkattang@brocade.com, rvadivel@brocade.com,
       vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This is an interim submission of Brocade BFA FC SCSI Driver for code review.
We moved FC protocol/port state machine part of the driver to the firmware to
make the driver simpler. We also implemented the code review comments received
from last submission which include: 1) replaced bfa specific list management
routines by standard linux list implemetation. 2) Minor fixes to naming,
Makefile, kconfig etc. 3) Other review comments that were pointed out
in regard to storing return values and use them as error codes etc., 
4) We are still considering the comments from Eike regarding using devres for
our driver and this patch does not have that feature but fixes all other comments.

The driver submitted now is fully functional.

It contains a serial of 5 patches generated using 2.6.29 kernel. Here is
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
