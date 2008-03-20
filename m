Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYCTVsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYCTVsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbYCTVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:48:28 -0400
Received: from mail.tmr.com ([64.65.253.246]:44564 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332AbYCTVs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:48:27 -0400
Message-ID: <47E2DBA7.6050708@tmr.com>
Date: Thu, 20 Mar 2008 17:48:23 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>
CC: linux-kernel@vger.kernel.org, Jeff Burke <jburke@redhat.com>
Subject: Re: CPU siblings
References: <1206028996.5225.6.camel@jcmlaptop>
In-Reply-To: <1206028996.5225.6.camel@jcmlaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> Yo,
> 
> Myself and a colleague were just discussing the output of /proc/cpuinfo,
> specifically the CPU siblings field. He pointed out/we think that this
> historically was supposed to be number of HT siblings for a given CPU.
> 
> The actual value of that field comes from the Hamming Weight (number of
> set bits) of the per_cpu cpu_core_map variable, which supposedly is
> "representing HT and core siblings of each logical CPU", i.e. both HT
> siblings and additional cores within the same CPU package.
> 
> Does this mean that "siblings" needs renaming? (doesn't it come
> originally from "HT siblings"? or is it supposed to be both?). More
> importantly, what's the correct way to determine number of HTs?
> 
Related topic: Intel has announced that some of their new CPU lines will 
once again have SMT in each core. Just the thought of multiple sockets 
with multiple core, with multiple threads and shared L3 cache sounds 
like a scheduling nightmare.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
