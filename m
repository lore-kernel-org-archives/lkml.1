Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZLDIkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZLDIkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZLDIkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:40:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41729 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbZLDIkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:40:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/7] some page_referenced() improvement
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Message-Id: <20091204173233.5891.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Dec 2009 17:40:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

here is my refactoring and improvement patchset of page_referenced().
I think it solve Larry's AIM7 scalability issue.

I'll test this patches on stress workload at this weekend. but I hope to
receive guys review concurrently.


