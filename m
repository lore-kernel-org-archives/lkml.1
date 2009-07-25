Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZGYFXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZGYFXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 01:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZGYFXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 01:23:06 -0400
Received: from gate07out.mcdata.com ([144.49.194.4]:46328 "EHLO
	mx30.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZGYFXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 01:23:05 -0400
X-IronPort-AV: E=Sophos;i="4.43,268,1246863600"; 
   d="scan'208";a="86151761"
Date: Fri, 24 Jul 2009 22:23:03 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200907250523.n6P5N3UH021315@swe57.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 0/14] bfa: Brocade BFA FC SCSI driver (overview)
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rvadivel@brocade.com, vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

After two unsuccessful submissions, I am retrying by further reducing the size
of each individual patch.

In this submission, we completed all the pening works in our last submission
in April, including:
1) Added support of Brocade PCIe FCOE HBA.
2) Cleaned up FC state machine code.
3) Completed implementing code review comments received from the open source
community.

It contains a serial of 14 patches generated using 2.6.30.1 kernel. Here is
a brief description of each patch:

[PATCH 1/14]: SCSI LLD driver code, module init/exit, PCI and SCSI host entry
points, interrupt handler, and sysfs interface etc. 

[PATCH 2/14]: Hardware/FW access code. part-1

[PATCH 3/14]: Hardware/FW access code. part-2

[PATCH 4/14]: Hardware/FW access code. part-3

[PATCH 5/14]: Hardware/FW access code. part-4

[PATCH 6/14]: FC state machines. part-1

[PATCH 7/14]: FC state machines. part-2

[PATCH 8/14]: FC state machines. part-3

[PATCH 9/14]: FC state machines. part-3

[PATCH 10/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-1

[PATCH 11/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-2

[PATCH 12/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-3

[PATCH 13/14]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver 

[PATCH 14/14]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
