Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZGGJkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZGGJkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZGGJkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:40:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36108 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZGGJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:40:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: [RFC PATCH 0/2] fix unnecessary accidental OOM problem on concurrent reclaim
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090707182947.0C6D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  7 Jul 2009 18:40:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series depent on "OOM analysis helper patches" series.

Current reclaim logic doesn't consider concurrent reclaim. Then it makes
accidental OOM on many CPU systems.

I think this patch series addresses its issue.



