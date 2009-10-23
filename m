Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZJWSh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZJWSh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZJWSh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:37:58 -0400
Received: from mga05.intel.com ([192.55.52.89]:54850 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752551AbZJWSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,613,1249282800"; 
   d="scan'208";a="506755728"
Message-ID: <4AE1F807.9060907@linux.intel.com>
Date: Fri, 23 Oct 2009 11:37:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perf timechart: Use pr_debug to report unknown header
 types
References: <1256320245-8439-1-git-send-email-acme@redhat.com> <4AE1EE1B.2000500@linux.intel.com> <20091023183107.GA4132@ghostprotocols.net>
In-Reply-To: <20091023183107.GA4132@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 23, 2009 at 10:55:39AM -0700, Arjan van de Ven escreveu:
>> Arnaldo Carvalho de Melo wrote:
>>> It was using eprintf that checked if verbose was !zero, when I converted
>>> to pr_*() I made the mistake of changing it to pr_warning which caused
>>> 'perf timechart' output to be way too verbose.
>>>
>> nack...
>>
>> if you EVER hit one of these you have a very very serious problem.
>> hiding that is never the right thing to do. I should make this a fatal
>> event instead.
> 
> OK, so I actually fixed a bug as those messages weren't being noticed if
> -v wasn't used! :-)
> 
> Please take a look at latest tip to see all those messages.
> 
> - Arnaldo

I'm pretty sure latest -tip broke timechart; Frederic tends to have a habit of doing so occasionally :)

