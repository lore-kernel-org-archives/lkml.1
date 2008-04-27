Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYD0QA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYD0QA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYD0QAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:00:06 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:50104 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbYD0QAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:00:05 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.26 0/3] RDMA/cxgb3: fixes and enhancements for 2.6.26
Date: Sun, 27 Apr 2008 10:54:56 -0500
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org, divy@chelsio.com, felix@chelsio.com
Message-Id: <20080427155456.31018.22282.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes some bugs as well as enabling peer-2-peer
applications including OpenMPI and HPMPI.

I hope this can make 2.6.26.

NOTE: The changes in patch 3 require a new firmware version.  I added
the version change to drivers/net/cxgb3/version.h in this patch so that
the changes that require the new firmware as well as the version bump
are all in one git commit.  This keeps things like 'git bisect' from
leaving the driver broken.

-- 
Steve.
