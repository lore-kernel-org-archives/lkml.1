Return-Path: <linux-kernel-owner+w=401wt.eu-S1031099AbXDYSwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031099AbXDYSwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031109AbXDYSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:52:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2547 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbXDYSwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jU1LNr/vQjtqbuDwHYFd1eafHhpVXClSn7OmJ+24YVluNBjuH58zfDwyjTCuemPIcxj9nw8vbvUJbgoBAd1XPfpgSjAf9L0/+2d9i7+izvfNbGzICfS7okMl7FcRReDXjcnnDhwLJeC1sJTTg5YG4pfwnVWw96hEBD24OxOFr2c=
Message-ID: <9e0cf0bf0704251152q5ed70a7agc93f32caddee3490@mail.gmail.com>
Date: Wed, 25 Apr 2007 21:52:00 +0300
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Christian Hesse" <mail@earthworm.de>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>, linux-kernel@vger.kernel.org,
       "Con Kolivas" <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070425173405.GE17074@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704182357.28107.mail@earthworm.de>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
	 <20070425173405.GE17074@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Pavel Machek <pavel@ucw.cz> wrote:
> Ok ok ok, suspend-to-disk has some other uses, too.
>
> But ... you are really using suspend-to-disk as a workaround for "my
> desktop takes too much power when idle". Imagine pressing "lock
> screensaver" combination, and your machine going to low power mode
> (3W?), immediately. (Quiet, too; you can't generate much noise for
> 3W). In the morning, you'd just press any key, machine would power up,
> immediately... ok, you'd have to ifconfig eth0 down, so that spurious
> packets on the local net would wake your machine, with all its fans
> etc.
>                                                                 Pavel

You are assuming that:
1. You have battery backup, or external power never fail.
2. You don't disconnect the filesystem from the device.
3. The security level of turned on device equals to a turned off one.
4. You turn on the same device that turned off.
5. You do not wish to boot another OS on this machine.

None of the above are always true... but why assume?
Just make this work... If Nigel wish to maintain this please let him,
you can be in charge of the s2ram.

Best Regards,
Alon Bar-Lev.
