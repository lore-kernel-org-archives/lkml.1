Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZI2Kg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZI2Kg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZI2Kg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbZI2Kgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:36:47 -0400
Date: Tue, 29 Sep 2009 12:34:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv2 4/4] scsi: export scsi_tgt_if.h
Message-ID: <20090929103445.GE11183@redhat.com>
References: <cover.1254220284.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1254220284.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header scsi_tgt_if.h is used by the SCSI target
framework (tgt) (http://stgt.berlios.de/).
Export it from kernel.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/scsi/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index a61932c..d798db8 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -4,3 +4,4 @@ header-y += scsi.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
 header-y += scsi_bsg_fc.h
+header-y += scsi_tgt_if.h
-- 
1.6.5.rc2
