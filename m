Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbXCOWRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbXCOWRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbXCOWPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:32 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33689 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbXCOWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 31 of 33] IB/ipath - remove duplicate stuff from ipath_verbs.h
X-Mercurial-Node: 9f6468cddf59f26e087d100980a11ee9f1af4f56
Message-Id: <9f6468cddf59f26e087d.1173995115@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:15 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Robert Walsh <robert.walsh@qlogic.com>
# Date 1173994465 25200
# Node ID 9f6468cddf59f26e087d100980a11ee9f1af4f56
# Parent  bf280d5f83d59788b58c17ff206bc3f54271a790
IB/ipath - remove duplicate stuff from ipath_verbs.h

ipath_verbs.h has some duplicate stuff.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r bf280d5f83d5 -r 9f6468cddf59 drivers/infiniband/hw/ipath/ipath_verbs.h
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h	Thu Mar 15 14:34:25 2007 -0700
@@ -731,8 +731,6 @@ int ipath_query_srq(struct ib_srq *ibsrq
 
 int ipath_destroy_srq(struct ib_srq *ibsrq);
 
-void ipath_cq_enter(struct ipath_cq *cq, struct ib_wc *entry, int sig);
-
 int ipath_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
 
 struct ib_cq *ipath_create_cq(struct ib_device *ibdev, int entries,
