Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXI0I3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXI0I3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXI0I3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:29:12 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46362 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXI0I3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:29:11 -0400
Message-ID: <46FB6958.2080402@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2007 13:57:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Guillaume Chazarain <guichaz@yahoo.fr>, linux-kernel@vger.kernel.org,
       balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, oleg@tv-sign.ru
Subject: Re: [PATCH 1/8] taskstats: fix indentation of long argument lists
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr> <20070926130144.78ab9491.akpm@linux-foundation.org>
In-Reply-To: <20070926130144.78ab9491.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 26 Sep 2007 19:08:18 +0200
> Guillaume Chazarain <guichaz@yahoo.fr> wrote:
> 
>> Align with the opening parenthesis.
>>
>> Changelog since V1 (http://lkml.org/lkml/2007/9/21/527):
>> - renamed fill_threadgroup() and add_tsk() to respectively
>> fill_threadgroup_stats() and add_tsk_stats() as suggested by Balbir Singh.
>> - added braces around do/while.
>> - added patch to unbreak binary compatibility between taskstats v5/v6.
>> - split further by preparing the bacct/xacct before the main patch.
>> - some indentation fixes.
> 
> It is unclear to me whether this patch series replaces, augments or
> conflicts with your earlier patch series starting with "taskstats: separate
> PID/TGID stats producers to complete the TGID ones".
> 
> But it doesn't matter much - I think I'll duck both patch series for now. 
> The gap between mainline and -mm is so large that it is becoming
> unmanageable so let's concentrate on the review and stabilisation work for
> now please, rather than adding more stuff.
> 
> Also, I don't think we're seeing enough review and test from people on
> these patch series - I don't have time to do it all.  (Well, apparently I
> do, but I don't think it's a good situation).

Hi, Andrew,

I've been able to review some of these patches, but not test them.
I'll find some time to test these patches.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
