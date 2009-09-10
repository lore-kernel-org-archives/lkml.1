Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZIJGaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZIJGaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbZIJGaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:30:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56506 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZIJGaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:30:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, <stable@kernel.org>
Subject: [PATCH 0/2] android: fix build error 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090910152551.DB3C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 15:30:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0753ba01 (mm: revert "oom: move oom_adj value") reverted some
regression patch. but it didn't revert one oom retrieved driver patch
(it is android lowoomkiller in staging tree).

This patch series fixes it.
	patch [1/2] is for 2.6.31 stable tree
	patch [2/2] is for -mm tree

-mm tree need both [1/2] and [2/2].

Thanks.



