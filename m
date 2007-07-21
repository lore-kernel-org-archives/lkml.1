Return-Path: <linux-kernel-owner+w=401wt.eu-S934114AbXGUVad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114AbXGUVad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761519AbXGUVa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:30:26 -0400
Received: from mail.tmr.com ([64.65.253.246]:54736 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760669AbXGUVaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:30:25 -0400
Message-ID: <46A27AE7.9050706@tmr.com>
Date: Sat, 21 Jul 2007 17:30:15 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070716 SeaMonkey/1.1.3
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Final glitch1 report WRT cfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At least on my hardware, the cfs in 2.6.22-git13 runs as smoothly as the 
perfect smoothness of cfs-v13, with two tuning changes:
  sched_stat_granularity_ns = 1000000
  sched_features = 14

The change in "features" made a major improvement.

Having identified the cause of the better smoothness in the older 
version, I'm going to put my efforts into other characterizations. The 
test source will remain on the server, but I'm won't do more with it 
unless someone finds it useful.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

