Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXDZUU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXDZUU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbXDZUU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:20:59 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:52529 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbXDZUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:20:58 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.22 0/5] iw_cxgb3: Bug Fixes + Firmware update
Date: Thu, 26 Apr 2007 15:20:57 -0500
To: rdreier@cisco.com, jeff@garzik.org
Cc: divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070426202057.24234.56383.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hey Roland,

Here are some bug fixes to the iw_cxgb3 driver that I'd like merged for
2.6.22.  The 1st patch has been posted before, but I didn't see it in
your for-2.6.22 branch, so I'm posting it again.  

Jeff, 

The last patch updates the cxgb3 required firmware version.  It is
included in this series because its required by the patch preceeding it
in the series.

Steve.

Shortlog:

Steve Wise:
      Fix TERM codes.
      Fail qp creation if the requested max_inline is too large.
      Initialize cpu_idx field in cpl_close_listserv_req message.
      Support for new abort logic.
      Update required firmware revision to 4.0.0.
