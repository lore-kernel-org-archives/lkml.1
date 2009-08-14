Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZHNAqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZHNAqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZHNAqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:46:38 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:62949 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbZHNAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:46:38 -0400
Message-ID: <4A84B3F0.80009@oracle.com>
Date: Thu, 13 Aug 2009 17:46:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-man@vger.kernel.org,
       akpm@linux-foundation.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] Add MAP_HUGETLB example to vm/hugetlbpage.txt V2
References: <cover.1250156841.git.ebmunson@us.ibm.com> <e9b02974a0cca308927ff3a4a0765b93faa6d12f.1250156841.git.ebmunson@us.ibm.com> <83949d066e2a7221a25dd74d12d6dcf7e8b4e9ba.1250156841.git.ebmunson@us.ibm.com> <617054c59f53f43f6fecfd6908cfb86ea1dd6f72.1250156841.git.ebmunson@us.ibm.com> <alpine.DEB.2.00.0908131449270.9805@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0908131449270.9805@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A84B3C9.0121:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 13 Aug 2009, Eric B Munson wrote:
> 
>> This patch adds an example of how to use the MAP_HUGETLB flag to
>> the vm documentation.
>>
>> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
>> ---
>> Changes from V1:
>>  Rebase to newest linux-2.6 tree
>>  Change MAP_LARGEPAGE to MAP_HUGETLB to match flag name in huge page shm
>>
>>  Documentation/vm/hugetlbpage.txt |   80 ++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 80 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
>> index ea8714f..d30fa1a 100644
>> --- a/Documentation/vm/hugetlbpage.txt
>> +++ b/Documentation/vm/hugetlbpage.txt
>> @@ -337,3 +337,83 @@ int main(void)
>>  
>>  	return 0;
>>  }
>> +
>> +*******************************************************************
>> +
>> +/*
>> + * Example of using hugepage memory in a user application using the mmap
>> + * system call with MAP_LARGEPAGE flag.  Before running this program make
> 
> s/MAP_LARGEPAGE/MAP_HUGETLB/

I'm (slowly) making source code examples in Documentation/ buildable,
as this one should be, please.

I.e., put it in a separate source file (hugetlbpage.txt can refer to the
source file if you want it to) and add a Makefile similar to other
Makefiles in the Documentation/ tree.

~Randy
