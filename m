Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZKKB5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZKKB5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 20:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZKKB5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 20:57:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49296 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbZKKB5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 20:57:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH v3 0/5] Sorting out sc.swap_cluster_max and kill hibernation specific reclaim logic
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 10:57:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, shrink_all_memory() and sc.swap_cluster_max have unnecessary
mess. We can cleanup it and kill some useless code.




