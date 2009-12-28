Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbZL1Uyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbZL1Uyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZL1Uyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:54:39 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:33496 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZL1Uyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:54:38 -0500
X-Authority-Analysis: v=1.0 c=1 a=IVLe9zejs7YA:10 a=d1eJ4v0dTb-FoUGZaW4A:9 a=3lEq9rxDlhKhTLmrO8g2Rd98QisA:4
X-Cloudmark-Score: 0
X-Originating-IP: 97.102.92.77
Message-ID: <4B391B0A.2040906@cfl.rr.com>
Date: Mon, 28 Dec 2009 15:54:34 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdomain> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <20091223170832.GH20539@basil.fritz.box> <20091227110947.GA1398@ucw.cz>
In-Reply-To: <20091227110947.GA1398@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2009 06:09 AM, Pavel Machek wrote:
> 
>>>> This might suggest that Mark's floppy controller doesn't like
>>>> deep C? Mark, did you try booting with processor.max_cstate=1
>>>> and HPET enabled?
>>>
>>> We have indeed had historical issues with floppy and sleep states before. 
>>
>> I removed that code when moving to 64bit (floppy driver disabling C1),
>> but perhaps we need some variant of it again (but it's the first such
>> report in many years). Although it would be sad to have it again on all 
>> systems.
> 
> C1 is hlt. Are you sure? I could see how C3 could cause problems (DMA
>  latency), but...
> 
> Can mark simply try with idle=poll?
> 
> 									Pavel
> 

The floppy still fails with idle=poll

Mark
