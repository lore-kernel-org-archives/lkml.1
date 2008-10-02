Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYJBAIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYJBAIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJBAIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:08:40 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:38604 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbYJBAIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:08:39 -0400
From: Tom Tucker <tom@opengridcomputing.com>
To: ericvh@gmail.com, linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org
Cc: rminnich@dancer.ca.sandia.gov, lionkov@lanl.gov, tom@opengridcomputing.com
Subject: [PATCH 00/03] RDMA Transport Support for 9P
Date: Wed,  1 Oct 2008 19:08:36 -0500
Message-Id: <1222906119-14310-1-git-send-email-tom@opengridcomputing.com>
X-Mailer: git-send-email 1.5.3.4.452.g09149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eric:

This patch series implements an RDMA Transport provider for 9P and 
is relative to your for-next branch.  The RDMA support is built on the 
OpenFabrics API and uses SEND and RECV to exchange data. This patch 
series has been tested with dbench and iozone.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Latchesar Ionkov <lionkov@lanl.gov>

[PATCH 01/03] 9prdma: RDMA Transport Support for 9P

 net/9p/trans_rdma.c |  996 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 996 insertions(+), 0 deletions(-)

[PATCH 02/03] 9prdma: Makefile change for the RDMA transport

 net/9p/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

[PATCH 03/03] 9prdma: Kconfig changes for the RDMA transport

 net/9p/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

