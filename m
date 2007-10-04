Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbXJDTcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbXJDTcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbXJDTco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:32:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbXJDTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:32:44 -0400
Message-ID: <47053FC7.2070308@redhat.com>
Date: Thu, 04 Oct 2007 15:32:23 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Frans Pop <elendil@planet.nl>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: Decreasing stime running confuses top
References: <200710031433.34504.elendil@planet.nl> <200710032127.42147.elendil@planet.nl> <20071003202446.GQ10199@1wt.eu> <200710040132.45062.elendil@planet.nl> <20071004191921.GA24011@dreamland.darkstar.lan>
In-Reply-To: <20071004191921.GA24011@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 03:19 PM, Luca Tettamanti wrote:
>>>>>> The latter seems to be utime ...decreasing. No wonder if
>>>>>> arithmetics will give strange results (probably top is using
>>>>>> unsigned delta?)...
>>>>> Hmm, minor miscounting from my side, stime seems more appropriate...
>>>> So, is it normal that stime decreases sometimes or a kernel bug?
>>>> /me expects the last...
>>> Let me guess... Dual core AMD64 ?
>> Nope: Intel(R) Pentium(R) D CPU 3.20GHz
> 
> I just notice the same thing here, with a Core2 Duo (which is supposed
> to have synced TSCs) and working HPET.
> 
>> The following may well be relevant.
>> With 2.6.22 and early 2.6.23-rc kernels (rc3-rc6) I often had this in my
>> kernel log (see http://lkml.org/lkml/2007/9/16/45):
>>    checking TSC synchronization [CPU#0 -> CPU#1]:
>>    Measured 248 cycles TSC warp between CPUs, turning off TSC clock.
>>    Marking TSC unstable due to check_tsc_sync_source failed
> 
> I don't see this though, TSCs are always syncronized between the 2
> cores.
> 

Is CONFIG_VIRT_CPU_ACCOUNTING set?

