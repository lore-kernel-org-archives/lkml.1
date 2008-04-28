Return-Path: <linux-kernel-owner+w=401wt.eu-S1764840AbYD1B5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764840AbYD1B5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 21:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYD1B47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 21:56:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56521 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbYD1B46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 21:56:58 -0400
X-Sasl-enc: 4pe3FEphDjlaRNA3WYgLHzAiNiXHALfSTZOcLdtI7+g1 1209347816
Message-ID: <48152EE0.6020507@fastmail.com.au>
Date: Mon, 28 Apr 2008 11:56:48 +1000
From: Allan Duncan <amd2345@fastmail.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 slow boot/reboot
References: <anfqC-7SO-15@gated-at.bofh.it> <anfqC-7SO-13@gated-at.bofh.it>
In-Reply-To: <anfqC-7SO-13@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allan Duncan wrote:
> Sergio Luis wrote:
>> Hello,
>> This weekend I got some time and decided to try out 2.6.25, but its 
>> booting process was _really_ slow in my laptop[1]. With 'old' 2.6.24.5 
>> my machine would take about 48 secs until it gave me the login prompt. 
>> And it would take about 22 seconds to reboot.
>>
>> With 2.6.25 I got from Linus git tree, my system takes about 4 min and 
>> 40 secs to boot. Sometimes looks like the system just freezes for a 
>> while, and then it continues the boot process. Rebooting also seems 
>> problematic here. After almost 3 minutes I had asked the system to 
>> reboot, it was still there. I typed reboot again and it then rebooted 
>> right away, weirdly.
> 
> I wonder if this relates to my 2.6.25 booting problem:
> I use lilo, v22.5.9, and with 2.6.25 the boot process stalls part way 
> through,
> then retries, etc for up to six attempts before succeeding.  When I can get
> the latest lilo to compile I'll try that, but I'm not holding my breath.
> 
> I get a display like "LILO............." and then the hang.  It is about 
> 14 dots,
> normally about twice that many before I get a new line and a message about
> BIOS check succeeding.

Now that I have rebooted I can be more accurate - the line says:
"Loading 2.6.25.............."

_and_ the problem is temperature dependant.  Once the box is warmed up it
momentarily pauses at the halting point above, when cold (below 10C) it
fails to get past this sticking point at all.  2.6.24.2 Just Works.
