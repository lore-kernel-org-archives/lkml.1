Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbXCEWGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbXCEWGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXCEWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:06:49 -0500
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:50900 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbXCEWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:06:47 -0500
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive  cpu scheduler
Date: Tue, 6 Mar 2007 08:52:06 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200703041800.53360.kernel@kolivas.org>
In-Reply-To: <200703041800.53360.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703060852.06729.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 18:00, Con Kolivas wrote:
> This message is to announce the first general public release of the
> "Rotating Staircase DeadLine" cpu scheduler.

>  A full rollup of the patch for 2.6.20:
> http://ck.kolivas.org/patches/staircase-deadline/sched-rsdl-0.26.patch

This patch has been queued at test.kernel.org (thanks Andy Whitcroft).

Here is a summary of the first few benchmarks from those tests rsdl 0.26 vs 
mainline 2.6.20 (However much it is that you value these particular 
benchmarks...) on amd64 4x:


Kernbench (lower elapsed is better);
=========
2.6.20:
Elapsed: 103.058s User: 351.974s System: 36.474s CPU: 376.6%
2.6.20-rsdl:
Elapsed: 102.848s User: 359.186s System: 36.666s CPU: 384.6%


tbench (higher is better):
======
2.6.20:
Throughput 165.5 MB/sec 1 procs
2.6.20-rsdl:
Throughput 261.418 MB/sec 1 procs


reaim (higher is better):
=====
2.6.20:
Max Jobs per Minute 500727.27
2.6.20-rsdl:
Max Jobs per Minute 612000.00

-- 
-ck
