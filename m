Return-Path: <linux-kernel-owner+w=401wt.eu-S966319AbZLHViz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966319AbZLHViz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbZLHViu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:38:50 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28966 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbZLHViu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:38:50 -0500
Subject: [PATCH 0/5] hpsa: fix a few more small things 
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 08 Dec 2009 15:38:06 -0600
Message-ID: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msleep instead of schedlue_timeout, rename a few too-generic
variable names, return SCSI_MLQUEUE_HOST_BUSY on command allocation
failure, fix (again) incorrect SCSI status reporting, suppress
noisy messages about unsupported SCSI REPORT LUNS.

---
These patches apply on top of the big hpsa patch already in Andrew Morton's tree.

Stephen M. Cameron (5):
      Use msleep() instead of schedule_timeout
      hpsa: rename too generic variable names
      hpsa:  Return SCSI_MLQUEUE_HOST_BUSY on command allocation failure.
      hpsa: Fix incorrect SCSI status reporting
      hpsa: suppress messages due to unsupport SCSI REPORT_LUNS


 drivers/scsi/hpsa.c |   93 +++++++++++++++++++++++++++------------------------
 drivers/scsi/hpsa.h |    4 +-
 2 files changed, 52 insertions(+), 45 deletions(-)

--
-- steve 
