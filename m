Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYJXUUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYJXUUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJXUUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:20:35 -0400
Received: from relay.gothnet.se ([82.193.160.251]:3882 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752273AbYJXUUe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:20:34 -0400
Message-ID: <4901A10D.1040403@tungstengraphics.com>
Date: Fri, 24 Oct 2008 03:18:53 -0700
From: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: nickpiggin@yahoo.com.au, airlied@linux.ie, yinghai@kernel.org,
       Peter Anvin <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Adding kmap_atomic_prot_pfn
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>	 <20081018203741.GA23396@elte.hu>	<1224366690.4384.89.camel@koto.keithp.com>	 <20081018223214.GA5093@elte.hu>	<1224389697.4384.118.camel@koto.keithp.com>	 <1224398496.5303.7.camel@koto.keithp.com>	<20081019175320.GA6442@elte.hu>	 <1224450291.5303.23.camel@koto.keithp.com>	<20081020115810.GC10594@elte.hu>	 <1224517744.5195.1.camel@koto.keithp.com>	<20081022093615.GF12453@elte.hu>	 <1224793332.22877.8.camel@koto.keithp.com>	 <20081023133840.d4eef579.akpm@linux-foundation.org>	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>	 <1224813015.22877.51.camel@koto.keithp.com>	 <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>	 <1224829359.22877.86.camel@koto.keithp.com>	 <49017A2C.5010504@tungstengraphics.com> <1224863327.22877.106.camel@koto.keithp.com>
In-Reply-To: <1224863327.22877.106.camel@koto.keithp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:
> On Fri, 2008-10-24 at 09:33 +0200, Thomas Hellström wrote:
>   
>> Keith,
>>
>> What you actually are doing here is claiming copyright on code that 
>> other people have written, and tighten the export restrictions. 
>> kmap_atomic_prot_pfn() appeared long ago in drm git with identical code 
>> and purpose, but with different authors, and iounmap_atomic is identical 
>> to kunmap_atomic.
>>     
>
> Yeah, I just stuck my usual license header on it and didn't think about
> authorship. I'll fix that, once we figure out what the appropriate name
> is.
>
> But, as this code is clearly a trivial adaptation of the existing kernel
> code, it should carry a GPLv2 license. I'm also not particular as to the
> EXPORT restriction, I was just following the EXPORT advice given for the
> other newly exposed kernel symbols we're using.
>
>   
Thanks, Keith.

If there is a chance that people who do want the EXPORT_SYMBOL_GPL 
restriction are OK to go with just EXPORT_SYMBOL(), I guess that would 
fit best considering what's already exported and doable in drivers today.

/Thomas








