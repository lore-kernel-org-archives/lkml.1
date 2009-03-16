Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbZCPSlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbZCPSlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZCPSkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:40:51 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:48833 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZCPSku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:40:50 -0400
Message-ID: <49BE9D21.6080400@krogh.cc>
Date: Mon, 16 Mar 2009 19:40:33 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903092109460.19207@localhost.localdomain> <alpine.LFD.2.00.0903101103510.29264@localhost.localdomain> <49B6C2B8.7000407@krogh.cc> <alpine.LFD.2.00.0903102107580.29264@localhost.localdomain> <49BD5CB6.1030700@krogh.cc>
In-Reply-To: <49BD5CB6.1030700@krogh.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Thomas Gleixner wrote:
> 
>> slow calibration path on every boot on your machine.
>>
>>     (tscmax - tscmin) / avg = 0.064 (result from third run)
>>
>> On my test machines I get values below 0.02
>>
>> While it's statistically not really correct we still can use that info
>> to catch cases like we see on your machines.
>>
>>> While booting up I saw this one on the serial console..
>>> root@quad12:~# hwclock --systohc
>>> Cannot access the Hardware Clock via any known method.
>>> Use the --debug option to see the details of our search for an access 
>>> method.
>>> root@quad12:~# hwclock --systohc --debug
>>> hwclock from util-linux-ng 2.13.1
>>> hwclock: Open of /dev/rtc failed, errno=2: No such file or directory.
>>> No usable clock interface found.
>>> Cannot access the Hardware Clock via any known method.
>>
>> Can you provide your .config file please ?
> 
> http://krogh.cc/~jesper/config-2.6.29-rc8.txt
> 
> I testet the attached patch.. and after 1.5 hours it seems to work. I'll 
> remain on this one at least a day to see how it works. I'll keep it on 
> for now and report back in 24 hours or so.
> 
> Its still using tsc as clock-source.

No resets after 24 hours..  it works.

-- 
Jesper
