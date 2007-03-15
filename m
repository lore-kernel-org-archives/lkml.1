Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbXCOJXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbXCOJXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXCOJXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:23:11 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56345 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbXCOJXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:23:10 -0400
Message-ID: <45F9107C.8090506@vmware.com>
Date: Thu, 15 Mar 2007 01:23:08 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jaroslav Kysela <perex@suse.cz>, Lee Revell <rlrevell@joe-job.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: alsa was Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr> <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com> <20070314084155.GA3993@ucw.cz> <Pine.LNX.4.61.0703141644400.8322@tm8103.perex-int.cz> <20070315090330.GF16330@elf.ucw.cz> <20070315091048.GA17886@elf.ucw.cz>
In-Reply-To: <20070315091048.GA17886@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>> 	download & install alsalib
>> 	download & install alsautils
>> 	create 1007 nodes in /dev

I really hope you meant permission 1007 nodes, not 1007 nodes!  I'm 
checking right now, and if the latter is the case, I'm going to 
uninstall alsa, even if that means my computer will forever be silent, 
it will be silent in protest.

> (Just for the record, I should note that networking is misdesigned in
> similar way; that's why we have eth0 instead of /dev/eth0, and need
> special tools to rename network interface. But this mistake dates to
> BSD days or something, so we got used to it... and at least you do not
> need to keep libnetwork up to date to keep your  net devices working.
>
> So networking provides _ugly_ hardware abstraction, but it provides
> it).
>   

I might add it got only worse with wireless support, now you can not 
configure card without both ifconfig and iwconfig, so not only is the 
API diverging, the userspace tools to manage it are doing so as well.

Zach
