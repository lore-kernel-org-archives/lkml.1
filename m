Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZAZS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZAZS1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZAZS1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:27:00 -0500
Received: from mx2.compro.net ([216.54.166.4]:12894 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZAZS07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:26:59 -0500
X-IronPort-AV: E=Sophos;i="4.37,326,1231131600"; 
   d="scan'208";a="3320699"
Message-ID: <497E0072.7000500@compro.net>
Date: Mon, 26 Jan 2009 13:26:58 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Petkov, Borislav" <borislav.petkov@amd.com>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
 processor
References: <497322CC.7050900@cfl.rr.com> <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com> <49759499.4050708@cfl.rr.com> <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com>
In-Reply-To: <497A48D5.9040904@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Andreas Herrmann wrote:
>> On Fri, Jan 23, 2009 at 10:34:43AM +0100, Mark Hounschell wrote:
>>> Mark Hounschell wrote:
>>>> The MB is a Biostar TA770+. It is not yet listed as one with new
>>>> BIOS support for the Phenom-II. Only the TA770+ SE is at the moment.
>>>> The only difference in the Sata port arrangement and the BIOS type.
>>>>
>>>> I guess I'll just keep pinging them.
>>> OK I have now the official bios for this CPU/MB combo. I still cannot boot a
>>> 1000 HZ kernel.
>> Looking at the Biostar pages I am still not completely convinced that
>> your CPU/MB combo is supported. At least it is not listed there.
>> So far TA770 A2+ SE, rev. 6.X, is listed. Did the Biostar folks confirm you
>> that your mobo model/revision is supported, too?
>>
> 
> The BIOS came from http://www.biostar.cn/upload/Bios/A78XAC25.BST.rar
> 
> The BIOSTAR folks supporting the US seem to be asleep. I've never gotten an
> actual response from them and have tried on 3 other occasions for other things.
> 
>>>  Here is my new dmesg while running a 250Hz kernel.
>> ...
>>
>>> Linux version 2.6.26.8 (root@harley) (gcc version 4.3.1 20080507 (prerelease)
>> ...
>>> CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
>> ...
>>> CPU1: AMD Phenom(tm) II X4 940 Processor stepping 02
>> ...
>>> CPU2: AMD Phenom(tm) II X4 940 Processor stepping 02
>> ...
>>> CPU3: AMD Phenom(tm) II X4 940 Processor stepping 02
>> Looks good so far.
>>
>>> eth0: no IPv6 routers present
>>> warning: `ntpd' uses deprecated v2 capabilities in a way that may be insecure.
>>> hda-intel: Invalid position buffer, using LPIB read method instead.
>>> NET: Registered protocol family 4
>>> NET: Registered protocol family 3
>>> NET: Registered protocol family 5
>> This reminds me of some system hangs with older kernels when C1E was
>> activated.
>>
>> Can you please try to boot with idle=poll, or idle=mwait, or nolapic_timer
>> when using 2.6.26.X?
>> Can you also try to boot .27 or .28?
>>
> 
> OK, I tried all the above on 2.6.26.8 ann 2.6.27.10. No difference.
> 
> Regards
> Mark
> 

If there is anything else I can try, I'm at your disposal.

Regards
Mark
