Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbYAUUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbYAUUmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYAUUmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:42:08 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:50197 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbYAUUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:42:07 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH RESEND 0/3] RDMA/cxgb3 fixes
Date: Mon, 21 Jan 2008 14:41:30 -0600
To: rdreier@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080121204130.3820.11053.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Roland,

Please include these three iw_cxgb3 fixes for 2.6.25.  The first two fix
bugs found doing Lustre testing, and the last patch correctly marks
privileged qps.

Shortlog:
      RDMA/cxgb3: Flush the RQ when closing.
      RDMA/cxgb3: fix page shift calculation in build_phys_page_list()
      RDMA/cxgb3: Mark qp as privileged based on user capabilities.

-- 
Steve.
