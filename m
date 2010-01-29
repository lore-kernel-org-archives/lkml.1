Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649Ab0A2DNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0A2DNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 22:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640Ab0A2DNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 22:13:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54978 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab0A2DNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 22:13:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B625296.5090903@np.css.fujitsu.com>
Date: Fri, 29 Jan 2010 12:14:30 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] tip tree - No irq handler for vector (irq -1)
References: <4B6143C5.7060602@cn.fujitsu.com>	 <1264709113.2849.14.camel@sbs-t61.sc.intel.com>	 <4B62366E.6040207@cn.fujitsu.com> <1264727895.2849.70.camel@sbs-t61.sc.intel.com> <4B6238DB.8010102@cn.fujitsu.com>
In-Reply-To: <4B6238DB.8010102@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maybe this problem is caused by that FIRST_DEVICE_VECTOR(IRQ 0x30)
does not assigned really.

Best Regards,
Jin Dongming

Li Zefan wrote:
> Suresh Siddha wrote:
>> On Thu, 2010-01-28 at 17:14 -0800, Li Zefan wrote:
>>> Suresh Siddha wrote:
>>>> Zefan,
>>>>
>>>> I have posted a fix for this.
>>>>
>>>> http://marc.info/?l=linux-kernel&m=126420641021426&w=2
>>>>
>>>> Can you please check if this indeed fixes your issue?
>>>>
>>> Yes, it works. Thanks!
>>>
>>> But I still saw this:
>>>
>>> do_IRQ: 1.48 No irq handler for vector (irq -1)
>> hmm.. Can you send me the complete kernel log after the above fix is
>> applied including the output of cat /proc/cpuinfo aswell as
>> cat /proc/interrupts?
>>
> 
> Sure, attached.
> 


