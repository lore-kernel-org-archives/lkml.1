Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYLPVIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYLPVIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYLPVIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:08:25 -0500
Received: from main.gmane.org ([80.91.229.2]:44402 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYLPVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:08:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Date: Tue, 16 Dec 2008 16:08:12 -0500
Message-ID: <494818BC.6050505@tmr.com>
References: <20081212183810.GA4390@ics.muni.cz> <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081213140214.GA21627@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081112 Fedora/1.1.13-1.fc9 pango-text SeaMonkey/1.1.13
In-Reply-To: <20081213140214.GA21627@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVMWu Fengguang wrote:
> On Sat, Dec 13, 2008 at 11:58:15AM +0200, Lukas Hejtmanek wrote:
>> On Sat, Dec 13, 2008 at 09:21:15AM +0800, Wu Fengguang wrote:
>>> I cannot reproduce it on 2.6.28-rc7, compiling 2.6.28-rc8...
>>>
>>> # free; echo 3 > /proc/sys/vm/drop_caches; free
>>>              total       used       free     shared    buffers     cached
>>> Mem:          1940        109       1831          0          0         42
>>> -/+ buffers/cache:         66       1873
>>> Swap:            0          0          0
>>>              total       used       free     shared    buffers     cached
>>> Mem:          1940         62       1877          0          0          7
>>> -/+ buffers/cache:         55       1884
>>> Swap:            0          0          0
>>>
>>>> once the whole memory is eaten by the cache, the system is pretty unusable.
>>> What's your kconfig?
>> attached.
> 
> OK I'll try it. I cannot produce the bug in my -rc8 configuration yet:
> 
> # free; echo 3 > /proc/sys/vm/drop_caches; free
>              total       used       free     shared    buffers     cached
> Mem:          1940        906       1033          0          0        761
> -/+ buffers/cache:        144       1795
> Swap:            0          0          0
>              total       used       free     shared    buffers     cached
> Mem:          1940        147       1793          0          0         19
> -/+ buffers/cache:        127       1813
> Swap:            0          0          0
> 

Could the problem be related to him running 2GB memory and you running... well, 
maybe a patches version of "free?" Or can you really run in 2MB, or am I misreading?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

