Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYJZTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYJZTBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 15:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYJZTBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 15:01:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:11871 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbYJZTBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 15:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HxWAtqwxxy9Oyu5sT1IZ7gkh+TjFh4yq4QSQM4gNkfR0r+hknZ40qA9DDAqPNI/1HR
         SRP8OoRjT61ps2mWFdH87qofRkedSAsZ81ooAkfa2+z8cDoBu2qvyh8pRtcc/w8eaAkF
         K8805Imacvi1YSTAQsrNPFU1JKPl69ZPNz/6Q=
Message-ID: <4904BE67.5000603@gmail.com>
Date: Sun, 26 Oct 2008 20:00:55 +0100
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080927)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected
 with 2.6.28-rc1-git1]
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org> <200810261855.47580.rjw@sisk.pl> <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org> <200810261914.40825.rjw@sisk.pl> <alpine.LFD.2.00.0810261117030.5200@nehalem.linux-foundation.org> <4904B6CC.7000403@gmail.com> <alpine.LFD.2.00.0810261133150.5200@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810261133150.5200@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds ha scritto:
> On Sun, 26 Oct 2008, Mikko C. wrote:
>   
>> Here's the full config: http://pastebin.com/d1481da76
>>     
>
> Ok, you do indeed not have HOTPLUG_CPU, so I'd be willing to bet this is 
> it.
>   
>> Does -rc1-git2 not have the fix yet?
>>     
>
> It should indeed be in -rc1-git2, so you can test it that way. 
>   

-git2 seems to fix all the issues I had:

- rmmod works fine
- Sound is back and apps using it don't freeze
- usb devices seem to be detected correctly
- I will test wifi, but the first boot was ok (if not, I guess it's not 
related to this).

I guess next time I'll be more patient and wait a little more before 
trying a new kernel as soon as it's out :P

Thanks!!!

Mikko
