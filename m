Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZGUXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZGUXG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbZGUXG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:06:58 -0400
Received: from mx10.brocade.com ([208.185.105.18]:36343 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbZGUXG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:06:57 -0400
X-IronPort-AV: E=Sophos;i="4.43,242,1246863600"; 
   d="scan'208";a="205068119"
Date: Tue, 21 Jul 2009 16:06:44 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200907212306.n6LN6i6j007166@swe57.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 0/6] bfa: Brocade BFA FC SCSI driver (overview)
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com,
       xmzhang@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

I have to resubmit the patch I posted a few days ago. It seems that one of
the patches I submitted never showed up in LKML (I tried twice), 
I suspect it got rejected due to its size. Now I am retrying by splitting that
patch into two.

In this submission, we completed all the pening works in our last submission
in April, including:
1) Added support of Brocade PCIe FCOE HBA.
2) Cleaned up FC state machine code.
3) Completed implementing code review comments received from the open source
community.

It contains a serial of 6 patches generated using 2.6.30.1 kernel. Here is
a brief description of each patch:

[PATCH 1/6]: SCSI LLD driver code, module init/exit, PCI and SCSI host entry
points, interrupt handler, and sysfs interface etc. 

[PATCH 2/6]: Hardware/FW access code.

[PATCH 3/6]: FC state machines.

[PATCH 4/6]: Common header files shared by linux driver,
hardware/FW access code, FC state machines.

[PATCH 5/6]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver 

[PATCH 6/6]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
