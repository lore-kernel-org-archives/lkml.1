Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYCEDuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYCEDuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 22:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYCEDum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 22:50:42 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56531 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYCEDul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 22:50:41 -0500
Message-ID: <47CE183C.7040105@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 09:19:16 +0530
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
References: <200803030316.07165.rjw@sisk.pl> <20080304112741.GA13428@linux.vnet.ibm.com> <1204682782.3248.189.camel@ymzhang>
In-Reply-To: <1204682782.3248.189.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> On Tue, 2008-03-04 at 16:57 +0530, Dhaval Giani wrote:
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
>>> Subject		: 2.6.25-rc1: volanoMark 45% regression
>>> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
>>> Date		: 2008-02-13 10:30
>>> References	: http://lkml.org/lkml/2008/2/13/128
>>> Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>>> 		  Balbir Singh <balbir@linux.vnet.ibm.com>
>>  
>> Peter's revert of the load balance patches should fix this one. Yanmin,
>> could you please confirm if the patch at
>> http://lkml.org/lkml/2008/2/25/202 helps?
> I tested it against 2.6.25-rc3 on my 16-core tigerton machine. It really improves
> volano result although it doesn't recover all the result.
> Comparing with 2.6.24, without the patch, volanoMark has about 50% regression
> with 2.6.25-rc3. With the patch, volanoMark has about 15% regression.
> 

Have you had a chance to git-bisect the culprit after the revert?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
