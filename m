Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZKLSrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZKLSrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZKLSrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:47:42 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12180 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZKLSrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:47:42 -0500
Subject: [PATCH 00/11] cciss: driver updates 
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:09 -0600
Message-ID: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates for cciss, main items are: retry driver initiated commands
on unit attention condition, do not automatically rescan for devices
on unit attention, support for more scatter gather elements and larger
transfers.
---

Alex Chiang (1):
      cciss: Make device attributes static

Don Brace (1):
      cciss: Add enhanced scatter-gather support.

Stephen M. Cameron (9):
      cciss: Fix problem with remove_from_scan_list on driver unload
      cciss:  Retry driver initiated cmds with unit attention condition
      cciss:  Remove the "withirq" parameter from various functions where possible
      cciss: clean up code in cciss_shutdown
      cciss: remove sendcmd() as it is no longer used.
      cciss: fix typo that causes scsi status to be lost.
      cciss: Remove unnecessary check in scan_thread
      cciss: Do not automatically rescan on UNIT ATTENTION/LUN DATA CHANGED
      cciss: Fix weird usage of ENXIO in cciss_scsi.c


 drivers/block/cciss.c      |  549 +++++++++++++++++++++-----------------------
 drivers/block/cciss.h      |   18 +
 drivers/block/cciss_cmd.h  |    7 -
 drivers/block/cciss_scsi.c |    4 
 4 files changed, 283 insertions(+), 295 deletions(-)

-- 
-- steve
