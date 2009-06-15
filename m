Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZFOLP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZFOLP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZFOLOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:14:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45669 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZFOLOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:14:43 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Two fixes for patch vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
Date: Mon, 15 Jun 2009 12:14:40 +0100
Message-Id: <1245064482-19245-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches fix up problems to patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
identified by Kosaki.

 Documentation/sysctl/vm.txt |   12 ++++++++----
 mm/vmscan.c                 |    6 +++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

