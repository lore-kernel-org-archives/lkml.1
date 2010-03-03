Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0CCH3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:29:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:38471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0CCH3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:29:53 -0500
Message-ID: <4B8E0FBC.7080702@kernel.org>
Date: Wed, 03 Mar 2010 16:29:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>
Subject: [GIT PULL] workqueue changes for 2.6.34-rc1
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 07:29:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following workqueue branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

As cmwq still is going through reviews, the branch contains only two
minor changes - one to beef up comment, the other to make
flush_workqueue() return when sure deadlock can be predicted.

Merging into 3a5b27bf6f29574d667230c7e76e4b83fe3014e0 doesn't cause
any conflict.

Thanks.

==================
Summary of changes
==================

Alan Stern (1):
      workqueue: warn about flush_scheduled_work()

Simon Kagstrom (1):
      workqueue: return on workqueue recursion

 kernel/workqueue.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

--
tejun
