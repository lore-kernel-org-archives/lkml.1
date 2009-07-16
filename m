Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZGPAvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZGPAvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZGPAvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:51:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37002 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZGPAvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:51:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 0/3] Account the number of isolate pages
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 09:51:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch series have following three patches.

[1/3] Rename pgmoved variable in shrink_active_list()
[2/3] mm: shrink_inactive_lis() nr_scan accounting fix fix
[3/3] add isolate pages vmstat

[1/3] and [2/3] are trivial code neating. [3/3] is the heart of this fix.





