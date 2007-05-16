Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbXEPPYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbXEPPYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbXEPPYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:24:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:30441 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbXEPPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:24:03 -0400
Message-ID: <d4cf37a60705160824q17360efay2e1d6ead80ebe4fd@mail.gmail.com>
Date: Wed, 16 May 2007 08:24:01 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com
Subject: [PATCH] Make the scsi_wait_scan module only if SCSI_SCAN_ASYNC is enabled.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow for the possibility that even if modules are enabled
that scsi_wait_scan is only made if SCSI_SCAN_ASYNC is
enabled.

Signed-off-by: Wink Saville <wink@saville.com>
---
 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e62d23f..4ba6ee5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -244,6 +244,7 @@ config SCSI_SCAN_ASYNC
 config SCSI_WAIT_SCAN
        tristate
        default m
+       depends on SCSI_SCAN_ASYNC
        depends on SCSI
        depends on MODULES

-- 
1.5.2.rc0.g520d
