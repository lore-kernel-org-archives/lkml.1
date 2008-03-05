Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYCEGiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYCEGiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbYCEGiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:38:10 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34339 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbYCEGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:38:09 -0500
Message-ID: <47CE3F5B.3090100@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 12:06:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
References: <200803030316.07165.rjw@sisk.pl> <20080304112741.GA13428@linux.vnet.ibm.com> <1204682782.3248.189.camel@ymzhang>  <47CE183C.7040105@linux.vnet.ibm.com> <1204694154.3248.194.camel@ymzhang>
In-Reply-To: <1204694154.3248.194.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> On Wed, 2008-03-05 at 09:19 +0530, Balbir Singh wrote:
>> Zhang, Yanmin wrote:
>>> On Tue, 2008-03-04 at 16:57 +0530, Dhaval Giani wrote:
>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
>>>>> Subject		: 2.6.25-rc1: volanoMark 45% regression
>>>>> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
>>>>> Date		: 2008-02-13 10:30
>>>>> References	: http://lkml.org/lkml/2008/2/13/128
>>>>> Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>>>>> 		  Balbir Singh <balbir@linux.vnet.ibm.com>
>>>>  
>>>> Peter's revert of the load balance patches should fix this one. Yanmin,
>>>> could you please confirm if the patch at
>>>> http://lkml.org/lkml/2008/2/25/202 helps?
>>> I tested it against 2.6.25-rc3 on my 16-core tigerton machine. It really improves
>>> volano result although it doesn't recover all the result.
>>> Comparing with 2.6.24, without the patch, volanoMark has about 50% regression
>>> with 2.6.25-rc3. With the patch, volanoMark has about 15% regression.
>>>
>> Have you had a chance to git-bisect the culprit after the revert?
> How to bisect it if the reverted patch is submitted after the culprit patch?

Good question. What I would do is create a branch at the patches that caused the
regression and apply all patches (except the reverted patches to it, solving
conflicts if any) and run git-bisect that. But, I suspect it is a lot of work.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
