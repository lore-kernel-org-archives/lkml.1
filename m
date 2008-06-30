Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYF3HQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYF3HQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYF3HQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:16:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYF3HQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:16:31 -0400
Message-ID: <486887EB.5090304@cn.fujitsu.com>
Date: Mon, 30 Jun 2008 15:14:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>, rientjes@google.com
Subject: Re: [PATCH] doc: Document the relax_domain_level kernel boot argument
References: <20080630045640.20308.22031.sendpatchset@polaris-admin.engr.sgi.com> <486883D0.8070409@jp.fujitsu.com>
In-Reply-To: <486883D0.8070409@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Hi Paul,
> 
> Paul Jackson wrote:
>> From: Paul Jackson <pj@sgi.com>
>>
>> Document the kernel boot parameter: relax_domain_level=.
>>
>> Signed-off-by: Paul Jackson <pj@sgi.com>
>>
>> ---
>>  Documentation/cpusets.txt           |    3 +++
>>  Documentation/kernel-parameters.txt |    4 ++++
>>  2 files changed, 7 insertions(+)
>>
>> --- 2.6.26-rc5-mm3.orig/Documentation/cpusets.txt	2008-06-27 06:55:34.000000000 -0700
>> +++ 2.6.26-rc5-mm3/Documentation/cpusets.txt	2008-06-29 21:49:53.984674621 -0700
>> @@ -546,6 +546,9 @@ otherwise initial value -1 that indicate
>>   ( 4  : search nodes in a chunk of node [on NUMA system] )
>>   ( 5~ : search system wide [on NUMA system])
>>  
>> +The system default is 0 (no search).  The system default can be
>> +changed using the relax_domain_level= boot parameter.
> 
> The system default is architecture dependent. You can change your
> system's default using the relax_domain_level= boot parameter.
> 

but the system default is 0 by default. and 0 means no search no matter
what architecture is. ;)

> Thanks,
> H.Seto
> 
> 
