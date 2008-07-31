Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbYGaCcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbYGaCcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYGaCcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:32:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49970 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbYGaCcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:32:32 -0400
Message-ID: <489123E6.5070606@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 10:31:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] stop_machine: remove unused variable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/stop_machine.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e446c7c..af3c7ce 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -65,7 +65,6 @@ static void ack_state(void)
 static int stop_cpu(struct stop_machine_data *smdata)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	int uninitialized_var(ret);
 
 	/* Simple state machine */
 	do {
-- 
1.5.4.rc3

