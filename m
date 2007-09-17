Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbXIQUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbXIQUs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbXIQUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:48:19 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47072 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbXIQUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:48:18 -0400
Message-ID: <46EEE80D.6060808@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2007 02:18:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>
Subject: Re: [PATCH] Configurable reclaim batch size
References: <Pine.LNX.4.64.0709141519230.14894@schroedinger.engr.sgi.com> <1189812002.5826.31.camel@lappy> <Pine.LNX.4.64.0709171053040.26860@schroedinger.engr.sgi.com> <20070917215615.685a5378@lappy>
In-Reply-To: <20070917215615.685a5378@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 17 Sep 2007 10:54:59 -0700 (PDT) Christoph Lameter
> <clameter@sgi.com> wrote:
> 
>> On Sat, 15 Sep 2007, Peter Zijlstra wrote:
>>
>>> It increases the lock hold times though. Otoh it might work out with the
>>> lock placement.
>> Yeah may be good for NUMA.
> 
> Might, I'd just like a _little_ justification for an extra tunable.
> 
>>> Do you have any numbers that show this is worthwhile?
>> Tried to run AIM7 but the improvements are in the noise. I need a tests 
>> that really does large memory allocation and stresses the LRU. I could 
>> code something up but then Lee's patch addresses some of the same issues.
>> Is there any standard test that shows LRU handling regressions?
> 
> hehe, I wish. I was just hoping you'd done this patch as a result of an
> actual problem and not a hunch.

Please do let me know if someone finds a good standard test for it or a
way to stress reclaim. I've heard AIM7 come up often, but never been
able to push it much. I should retry.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
