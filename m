Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572Ab0AZKCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab0AZKCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860Ab0AZKCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:02:10 -0500
Received: from lucidpixels.com ([75.144.35.66]:46216 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0AZKCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:02:10 -0500
Date: Tue, 26 Jan 2010 05:02:08 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Hyperthreading on Core i7s: To use or not to use?
Message-ID: <alpine.DEB.2.00.1001260456210.14707@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Should the 'correct' kernel [CPU] configuration for a core i7 860/870..?

- Multi-core support
- Cores: 8
- SMT: Enabled/ON

>From CONFIG_SCHED_SMT:

   . SMT scheduler support improves the CPU scheduler's decision making      .
   . when dealing with Intel Pentium 4 chips with HyperThreading at a        .
   . cost of slightly increased overhead in some places. If unsure say       .
   . N here.                                                                 .

Does this also 'help' and/or 'apply' as much when dealing with Core i7s?

--

Quick little benchmark (pbzip2 -9 linux kernel source), the benchmark is 
really within the noise (8 on/off)
- Multicore(8)/HT(Off) = 73.72user 0.33system 0:09.50elapsed 779%CPU (0avgtext+0avgdata 458528maxresident
- Multicore(8)/HT(On) = 74.28user 0.40system 0:09.67elapsed 772%CPU (0avgtext+0avgdata 428304maxresident
- Multicore(4)/HT(On) = 68.76user 0.30system 0:17.44elapsed 396%CPU (0avgtext+0avgdata 213616maxresident)k

--

Has anyone done any in-depth benchmarking for the core i7s that have multiple
cores and HT disabled/enabled?

Justin.
