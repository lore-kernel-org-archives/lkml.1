Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbYGCVlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbYGCVlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbYGCVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:37:10 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:1100 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbYGCVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:37:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] sched: misc fixes for stable-25.y and 25-rt
To: stable@vger.kernel.org, linux-rt-users@vger.kernel.org,
       rostedt@goodmis.org, mingo@elte.hu
Cc: peterz@infradead.org, ghaskins@novell.com, linux-kernel@vger.kernel.org
Date: Thu, 03 Jul 2008 15:37:06 -0600
Message-ID: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Steven, Peter,
  I found a few minor issues w.r.t. the CFS load values during a few
  dequeue/enqueue operations in the 2.6.25 kernel.  I found these via
  code review as opposed to observing a bug in the field.  I believe
  at least the first issue is already fixed in 26-rcx.  I have
  confirmed that the issue is present in both 25.8-rt7 as well as
  stable-2.6.25.10.  These patches are against 25.8-rt7, though they
  should apply trivially to stable as well.  Please consider for
  inclusion in the next -rt if the -stable team does not pick them up
  immediately.

Stable team,
  Please consider these patches for 25.11 (assuming the appropriate acks
  from Ingo et. al. are recieved) though I do not believe they are
  considered significant risks and are therefore not urgent.

Feedback welcome..

Thanks!
-Greg
