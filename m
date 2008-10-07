Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYJGTNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYJGTNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 15:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYJGTMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 15:12:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:64060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYJGTMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 15:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,374,1220252400"; 
   d="scan'208";a="345082905"
Message-ID: <48EBB4A9.2010108@intel.com>
Date: Tue, 07 Oct 2008 12:12:41 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: "Renato S. Yamane" <yamane@diamondcut.com.br>,
       linux-kernel@vger.kernel.org, rjwysocki@sisk.pl,
       power-management_other@kernel-bugs.osdl.org
Subject: Re: [Bug 10797] Battery is drained after poweroff
References: <48E9F388.8040203@diamondcut.com.br> <20081007134223.GA1592@ucw.cz> <48EB88F2.3090100@diamondcut.com.br> <20081007190007.GB6604@elf.ucw.cz>
In-Reply-To: <20081007190007.GB6604@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2008 19:12:45.0722 (UTC) FILETIME=[AE1C5FA0:01C928B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2008-10-07 13:06:10, Renato S. Yamane wrote:
>> Pavel Machek wrote:
>> Renato S. Yamane wrote:
>>>> Can someone help us with this bug?
>>>> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
>>>>
>>>> Same problem is reported in Ubuntu:
>>>> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>
>>>>
>>>> This is not a hardware problem, because if the same laptop is poweroff
>>>> by Windows, battery charge don't change.
>>> ...and it is not linux problem because it works okay on my thinkpad. See? 
>> Yes, this is a Linux problem (at least in release >= 2.6.22)
>> This happening *only* in Linux (Kernel >=2.6.22).
> 
> Wow, now that's useful info.
> 
> I guess you _could_ do git bisect? ;-).
> 
>>>> And, if I suspend to ram/disk BEFORE poweroff, battery charge don't
>>>> change (suspend to ram/disk --> WakeUp --> Poweroff).
>>> Which machine is that? Can you find out which device eats power? (It
>>> should be warm).
>> This problem is happening in Toshiba Satellite M45-S355, Toshiba Equium
>> A100-306, HP DV8000, HP DV9500, Dell Latitude D630, Toshiba M110, Sony
>> Vaio VGN-S2XP, Toshiba Satellite A105-S4384, Toshiba Satellite M55-S3314
>> and Toshiba Satellite A105-S2201 as you can see in bug report listed above.
>>
>> And is impossible find wich device eats power (eaten current is too low,
>> and is not enought to make hot).
> 
> So how fast is it eating power... can you estimate Watts eaten?
> 									Pavel

perhaps wake-on-lan and friends are enabled? check the bios etc...

Auke
