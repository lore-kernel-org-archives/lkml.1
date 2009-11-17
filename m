Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZKQQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZKQQoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZKQQoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:44:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZKQQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:44:10 -0500
Message-ID: <4B02D2C1.2070502@zytor.com>
Date: Tue, 17 Nov 2009 08:43:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz> <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <20091117143456.GF15157@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20091117143456.GF15157@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 06:34 AM, Lennart Sorensen wrote:
> On Tue, Nov 17, 2009 at 11:59:29AM +0000, Alan Cox wrote:
>>> Trying rdmsr from msr-tools 1.2 gives me:
>>>
>>> # ./rdmsr -x 0x00001810
>>> rdmsr: CPU 0 cannot read MSR 0x00001810
>>>
>>> Hmm, now what?
>>
>> Beats me - I thought the region registers were read/write.
> 
> Actually it seems I can't read any MSRs on it.
> 
> Using the same kernel, same msr module, same rdmsr on a Geode LX system
> works fine.  I can read MSRs no problem.  Seems the msr module isn't
> working on the Geode SC1200 (and hence possibly the GX1).
> 

That would seem highly unlikely ... unless the MSR flag isn't exposed in
CPUID.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

