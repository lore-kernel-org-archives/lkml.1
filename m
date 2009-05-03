Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZECOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZECOhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 10:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZECOhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 10:37:25 -0400
Received: from mail001.aei.ca ([206.123.6.130]:41702 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZECOhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 10:37:24 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: cpuspeed vs x
Date: Sun, 3 May 2009 10:37:19 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-crc; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200905022201.36514.gene.heskett@verizon.net>
In-Reply-To: <200905022201.36514.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905031037.19969.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 May 2009 22:01:36 Gene Heskett wrote:
> Greetings all;
> 
> I'm not sure where I should send this.
> 
> When 30-rc4 came out, I built it, but this time I enabled the cpuspeed 
> governor stuffs, picking middle of the road options just to see if I could 
> feel any difference on this quad core phenom.
> 
> Booted up just fine, and ran till I left long enough for the blank screen & 
> monitor powerdown to take place.  An hour later I come in and jog the mouse to 
> wake things up & 30 seconds later its still blanked but I can see the lcd's 
> backlight is on, so I poke a few keys and I think the screen may have blinked 
> on for maybe one frame once.
> 
> Ctl-alt-bsp, terminal screen is fine, and startx works.  An hour later, whole 
> machine is powered down while I'm elsewhere again.  I fool with this, trying 
> to make sense of it for another half a day, then reboot to -rc3 and rebuild 
> -rc4 without that option, and something around 24 hours later it is still just 
> fine.
> 
> Is this a kernel problem, or an x problem?

rc4 has been unstable here with the same setup used with rc3.   An rc4 kernel
will not stay up 8 hours - rc3 would last days.  Stall symptoms differ.  Sometimes
X stalls, other times X will not respond but the cursor can be moved.  The strangest
was one that happened with X down.  In this case sysrq would not output anything
other than the title for the function requested...

I am not sure how to go about getting good debug info for this one.

I am using gentoo on amd64 (a 8450 on 790gx based mb) with gcc 4.3.3

Ed
