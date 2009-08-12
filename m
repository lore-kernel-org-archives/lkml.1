Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZHLIgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZHLIgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZHLIgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:36:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbZHLIgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:36:05 -0400
Message-ID: <4A827EE9.7090102@redhat.com>
Date: Wed, 12 Aug 2009 11:35:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Rusty Russell <rusty@rustcorp.com.au>, Minchan Kim <minchan.kim@gmail.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Page allocation failures in guest
References: <20090713115158.0a4892b0@mjolnir.ossman.eu>	<20090811083233.3b2be444@mjolnir.ossman.eu>	<4A811545.5090209@redhat.com>	<200908121249.51973.rusty@rustcorp.com.au>	<20090812081934.33e8280f@mjolnir.ossman.eu>	<4A8272B2.3030309@redhat.com> <20090812102225.5a2e2305@mjolnir.ossman.eu>
In-Reply-To: <20090812102225.5a2e2305@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2009 11:22 AM, Pierre Ossman wrote:
>>
>>> Will it still trigger the OOM killer with this patch, or will things
>>> behave slightly more gracefully?
>>>
>>>        
>> I don't think you mentioned the OOM killer in your original report?  Did
>> it trigger?
>>
>>      
>
> I might have things backwards here, but I though the OOM killer started
> doing its dirty business once you got that memory allocation failure
> dump.
>    

I don't think the oom killer should trigger on GFP_ATOMIC failures, but 
don't know for sure.  If you don't have a trace saying it picked a task 
to kill, it probably didn't.

-- 
error compiling committee.c: too many arguments to function

