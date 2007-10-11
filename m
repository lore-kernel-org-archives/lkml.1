Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXJKNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXJKNXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbXJKNXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:23:08 -0400
Received: from hall.aurel32.net ([88.191.38.19]:53485 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbXJKNXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:23:06 -0400
Message-ID: <470E23A0.5050500@aurel32.net>
Date: Thu, 11 Oct 2007 15:22:40 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
References: <1192053794.15601.47.camel@gaivota>	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>	 <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>	 <d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>	 <470DBDC7.8000304@aurel32.net> <d9def9db0710102331h68e1d9b0rf3095bd9e261ec21@mail.gmail.com>
In-Reply-To: <d9def9db0710102331h68e1d9b0rf3095bd9e261ec21@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger a écrit :
> On 10/11/07, Aurelien Jarno <aurelien@aurel32.net> wrote:
>> Markus Rechberger a écrit :
>>> On 10/11/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>> As such, the old and decrepit em28xx driver seems more useful to people,
>>>> since at least it supports the limited set of hardware on its own.
>>> it does not since it's broken and feature limited. On the other side
>> I have a device which works perfectly with it if you add the vendor and
>> product ID to the list. I don't really call that broken. And it doesn't
>> need a firmware.
>>
> 
> Aurelien,
> 
> the device you're using is around 2 years old. You're one of the lucky
> ones, I have tonns of support mails in my mail account from people who
> own almost a similar device but with different videodecoders which are
> not fully supported in the kernel or which worked and got broken
> during the time.
> It took me around 4 hours to debug such an issue last years remotly
> with an enduser (which includes that noone cared to ask me if I'm fine
> with such an update, neither did someone ask people who own such
> devices that they should test the changes).
> Please also take other devices and upcoming devices into account,
> since i'm willing to spend that time and since I'm in contact with
> various companies who provide several components of those devices.
> 

I agree I am lucky, but the fact is that the in-kernel driver supports
*some* devices, and *works* correctly for them. On the other side, your
driver supports more devices, but it is and *out-of-tree* driver.

Please either work to get your change merged, or stop complaining about
changes done to the in-kernel driver.

Moreover if you get a closer look at v4l-dvb git, you will see that the
changes proposed by Mauro are not em28xx specific, and is actually the
same change done on a lot of of v4l/dvb drivers.

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
