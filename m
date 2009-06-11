Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbZFKKZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbZFKKZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbZFKKZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:25:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57525 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623AbZFKKZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:25:13 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH for mmotm 0/5] introduce swap-backed-file-mapped count and fix vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 19:25:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, Wu Fengguang pointed out vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
has underflow problem.

This patch series introduce new vmstat of swap-backed-file-mapped and fix above
patch by it.





