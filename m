Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYAOAwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYAOAwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYAOAwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:52:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57279 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYAOAwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:52:45 -0500
Date: Tue, 15 Jan 2008 09:52:14 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/5] mem notifications v4
Cc: kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The /dev/mem_notify is low memory notification device.
it can avoid swappness and oom by cooperationg with the user process.

You need not be annoyed by OOM any longer :)
please any comments!


related discussion:
--------------------------------------------------------------
  LKML OOM notifications requirement discussion
     http://www.gossamer-threads.com/lists/linux/kernel/832802?nohighlight=1#832802
  OOM notifications patch [Marcelo Tosatti]
     http://marc.info/?l=linux-kernel&m=119273914027743&w=2
  mem notifications v3 [Marcelo Tosatti]
     http://marc.info/?l=linux-mm&m=119852828327044&w=2
  Thrashing notification patch  [Daniel Spang]
     http://marc.info/?l=linux-mm&m=119427416315676&w=2


Changelog
-------------------------------------------------
  v3 -> v4 (by KOSAKI Motohiro)
    o rebase to 2.6.24-rc6-mm1
    o avoid wake up all.
    o add judgement point to __free_one_page().
    o add zone awareness.

  v2 -> v3 (by Marcelo Tosatti)
    o changes the notification point to happen whenever
      the VM moves an anonymous page to the inactive list.
    o implement notification rate limit.

  v1(oom notify) -> v2 (by Marcelo Tosatti)
    o name change
    o notify timing change from just swap thrashing to
      just before thrashing.
    o also works with swapless device.




