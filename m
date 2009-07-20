Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbZGTGad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbZGTGad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 02:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZGTGaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 02:30:30 -0400
Received: from mx30.brocade.com ([144.49.194.4]:21937 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZGTGa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 02:30:29 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 02:30:29 EDT
X-IronPort-AV: E=Sophos;i="4.43,233,1246863600"; 
   d="scan'208";a="85457226"
Date: Sun, 19 Jul 2009 23:20:58 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200907200620.n6K6Kw2O011121@swe57.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com,
       xmzhang@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

In this submission, we completed all the pening works in our last submission
in April, including:
1) Added support of Brocade PCIe FCOE HBA.
2) Cleaned up FC state machine code.
3) Completed implementing code review comments received from the open source
community.

It contains a serial of 5 patches generated using 2.6.30.1 kernel. Here is
a brief description of each patch:

[PATCH 1/5]: SCSI LLD driver code, module init/exit, PCI and SCSI host entry
points, interrupt handler, and sysfs interface etc. 

[PATCH 2/5]: Hardware/FW access code and FC state machines.

[PATCH 3/5]: Common header files shared by linux driver specific,
hardware/FW access code, FC state machines.

[PATCH 4/5]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver 

[PATCH 5/5]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
