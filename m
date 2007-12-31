Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXLaAih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXLaAih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbXLaAiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:38:09 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:62957 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638AbXLaAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:38:06 -0500
Message-Id: <20071231001137.147986000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 31 Dec 2007 01:11:37 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 0/3] sched: hrtick and rt group scheduling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spend xmas implementing group scheduling for the realtime scheduling classes.
Its a tad raw, but seems to work for the trivial test cases I threw at it.

The hrtick stuff is unrelated but was still stuck in my sched queue.

Patches against .26-rc6-mm1

--

