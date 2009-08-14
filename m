Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZHNHRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZHNHRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 03:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZHNHRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 03:17:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60259 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZHNHRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 03:17:12 -0400
Message-ID: <4A850F4A.9020507@redhat.com>
Date: Fri, 14 Aug 2009 10:16:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com> <20090807121443.5BE5.A69D9226@jp.fujitsu.com> <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com> <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com> <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org>
In-Reply-To: <20090813211626.GA28274@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 12:16 AM, Johannes Weiner wrote:
>
>> - do not ignore the referenced bit
>> - if you see a run of N pages which all have the referenced bit set, do
>> swap one
>>
>>      
>
> But it also means destroying the LRU order.
>
>    

True, it would, but if we ignore the referenced bit, LRU order is really 
FIFO.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

