Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZHKPSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZHKPSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZHKPSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:18:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbZHKPSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:18:01 -0400
Message-ID: <4A818AF3.9050706@redhat.com>
Date: Tue, 11 Aug 2009 11:14:59 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>, andi.kleen@intel.com,
       Pavel Emelianov <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale better (v4)
References: <20090811144405.GW7176@balbir.in.ibm.com> <4A81863A.2050504@redhat.com>
In-Reply-To: <4A81863A.2050504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Prarit Bhargava wrote:
>
>
> Balbir Singh wrote:
>> Enhancement: Remove the overhead of root based resource counter 
>> accounting
>>
>>
>>   
>
> <snip>
>> Please test/review.
>>
>>   
> FWIW ...
>
> On a 64p/32G system running 2.6.31-git2-rc5, with RESOURCE_COUNTERS 
> off, "time make -j64" results in
>
> real    4m54.972s
> user    90m13.456s
> sys     50m19.711s
>
> On the same system, running 2.6.31-git2-rc5, with RESOURCE_COUNTERS on,
> plus Balbir's "Help Resource Counters Scale Better (v3)" patch, and 
> this patch, results in

Oops, sorry Balbir. 

I meant to write:

On the same system, running 2.6.31-git2-rc5, with RESOURCE_COUNTERS on, 
plus Balbir's "Help Resource Counters Scale Better (v4)" patch results 
in ...

Sorry for the typo,

P.
