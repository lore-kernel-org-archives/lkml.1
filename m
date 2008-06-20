Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYFTDSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYFTDSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 23:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYFTDS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 23:18:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46868 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYFTDS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 23:18:27 -0400
Message-ID: <485B2180.10507@us.ibm.com>
Date: Thu, 19 Jun 2008 22:18:24 -0500
From: Jon Tollefson <kniht@us.ibm.com>
Reply-To: kniht@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>
Subject: Re: 2.6.26-rc5-mm3: BUG large value for HugePages_Rsvd
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <485A8903.9030808@linux.vnet.ibm.com> <20080619171644.GC13275@shadowen.org>
In-Reply-To: <20080619171644.GC13275@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> On Thu, Jun 19, 2008 at 11:27:47AM -0500, Jon Tollefson wrote:
>   
>> After running some of the libhugetlbfs tests the value for
>> /proc/meminfo/HugePages_Rsvd becomes really large.  It looks like it has
>> wrapped backwards from zero.
>> Below is the sequence I used to run one of the tests that causes this;
>> the tests passes for what it is intended to test but leaves a large
>> value for reserved pages and that seemed strange to me.
>> test run on ppc64 with 16M huge pages
>>     
>
> Yes Adam reported that here yesterday, he found it in his hugetlfs testing.
> I have done some investigation on it and it is being triggered by a bug in
> the private reservation tracking patches.  It is triggered by the hugetlb
> test which causes some complex vma splits to occur on a private mapping.
>   
sorry I missed that

> I believe I have the underlying problem nailed and do have some nearly
> complete patches for this and they should be in a postable state by
> tommorrow.
>   
Cool.
> -apw
>   
Jon

