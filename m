Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbXJBRoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbXJBRoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXJBRn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:43:56 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51091 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbXJBRnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:43:55 -0400
Message-ID: <470282C8.5020105@us.ibm.com>
Date: Tue, 02 Oct 2007 10:41:28 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org,
       systemtap@sources.redhat.com
Subject: Re: [patch 3/3]  Trace sample
References: <1191342805.31351.11.camel@lc4eb748232119.ibm.com> <20071002101032.55403fef.randy.dunlap@oracle.com>
In-Reply-To: <20071002101032.55403fef.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 02 Oct 2007 09:33:25 -0700 David J. Wilder wrote:
> 
>> Trace example - Adds the trace example to samples/
>>
>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
>> ---
>>  samples/Kconfig            |    6 ++
>>  samples/Makefile           |    1 +
>>  samples/trace/Makefile     |    4 +
>>  samples/trace/fork_trace.c |  132 ++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 143 insertions(+), 0 deletions(-)
>>
>> diff --git a/samples/Kconfig b/samples/Kconfig
>> index 57bb223..e11c806 100644
>> --- a/samples/Kconfig
>> +++ b/samples/Kconfig
>> @@ -13,4 +13,10 @@ config SAMPLE_MARKERS
>>  	help
>>  	  This build markers example modules.
>>  
>> +config SAMPLE_TRACE
>> +	tristate "Build trace example -- loadable modules only"
>> +	depends on TRACE && m
> 
> The sample code uses kprobes, so this should also be:
> 
> 	depends on KPROBES
> 
> Is (are?) kprobes always needed for trace?


No, just the sample.

  If so, the documentation
> probably should mention that also (along with relay & debugfs).
> 
...
