Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYLKQy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYLKQy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbYLKQtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:20 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37726 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbYLKQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:16 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBQ1DJ-02-VNJ-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/9] oprofile: port to the new ring buffer
Date: Thu, 11 Dec 2008 17:41:54 +0100
Message-ID: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
X-OriginalArrivalTime: 11 Dec 2008 16:48:56.0947 (UTC) FILETIME=[5BCF8C30:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set ports cpu buffers in oprofile to the new ring buffer
provided by the tracing framework. The motivation here is to leave the
pain of implementing ring buffers to others. Oh, no, there are more
advantages. Main reason is the support of different sample sizes that
could be stored in the buffer. Use cases for this are IBS and Cell spu
profiling. Using the new ring buffer ensures valid and complete
samples and allows copying the cpu buffer stateless without knowing
its content. Second it will use generic kernel API and also reduce
code size. And hopefully, there are less bugs.

The patch set is also available here:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git ring_buffer

-Robert



