Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZKBHZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZKBHZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZKBHZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:25:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58706 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZKBHZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:25:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Nov 2009 16:22:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: [RFC][-mm][PATCH 0/6] oom-killer: total renewal
Message-Id: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, as discussed in "Memory overcommit" threads, I started rewrite.

This is just for showing "I started" (not just chating or sleeping ;)

All implemtations are not fixed yet. So feel free to do any comments.
This set is for minimum change set, I think. Some more rich functions
can be implemented based on this.

All patches are against "mm-of-the-moment snapshot 2009-11-01-10-01"

Patches are organized as

(1) pass oom-killer more information, classification and fix mempolicy case.
(2) counting swap usage
(3) counting lowmem usage
(4) fork bomb detector/killer
(5) check expansion of total_vm
(6) rewrite __badness().

passed small tests on x86-64 boxes.

Thanks,
-Kame

