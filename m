Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbXC0CIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbXC0CIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933929AbXC0CIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 22:08:20 -0400
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:57758 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933933AbXC0CIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 22:08:19 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][ 0/5] Staircase deadline v0.36
Date: Tue, 27 Mar 2007 13:07:56 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703271207.56851.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What follows is a clean major iteration of the (now) Staircase Deadline cpu 
scheduler.

Changes from RSDL v0.33:
- All accounting is moved to tasks in nanosecond resolution removing 
requirement for Rotation component entirely
- list_splice_tail is no longer required; dropped
- Nicer nice with smaller rr_intervals if HZ tolerates it
- Reworked SCHED_BATCH to keep same cpu bandwidith but lax latency
- Updated documentation

Patches that follow are for 2.6.21-rc5

Andrew please use these to replace the RSDL patches.

-- 
-ck
