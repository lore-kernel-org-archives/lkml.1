Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbXLNMe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbXLNMe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbXLNMeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:34:18 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:48529 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbXLNMeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:34:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 13:31:58 +0100
User-Agent: KMail/1.9.6
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       John Linville <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712141239.51809.mb@bu3sch.de> <20071214121617.GE23964@elte.hu>
In-Reply-To: <20071214121617.GE23964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141331.59410.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 13:16:17 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > The testers who did nothing but reported that the new driver did not 
> > > work on their hardware.
> > 
> > Which testers?
> 
> right in this thread Ray Lee is reporting:
> 
> | | Digging a little farther into it, it looks like b43 is barfing 
> | | partway through init as the firmware file it's looking for has 
> | | changed names. Perhaps that's the issue. I'll take a longer look at 
> | | this all tomorrow.
> 
> you are really in denial of reality. Just re-read this thread. Upon 
> re-reading this thread, try to imagine that you are in place of Ray Lee 
> (might be hard), that you had a working bcm43xx driver and that now you 
> try to get b43 to work. You are not a kernel hacker who knows this 
> driver, just an advanced user who'd like to give you some more feedback 
> about your shiny new code.

This user did get the following messages in dmesg:

b43err(dev->wl, "Firmware file \"%s\" not found "
       "or load failed.\n", path);
b43err(wl, "You must go to "
       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
       "and download the correct firmware (version 4).\n");

I'm not sure how I can improve that even more. There is a full URL
describing how to get the device workin in _full_ detail.

Yes. I know people don't read messages and immediately report
a "regression". But that is not my fault. Not in this case.

It's not rocket science to get b43 working. The way firmware is
installed did not change at all. (b43-fwcutter is still used).
So it's the very same procedure that user X already successfully
did when installing bcm43xx.

What should I do to improve the situation? Writing the message
all in uppercase? Maybe. I can do a patch, if people finally start reading
it then.

> > Ray Lee didn't even install the firmware. So it can't work by 
> > definition. That is not my fault.
> 
> which questions your basic skills of reading or of empathy. Why is a 
> reasonable firmware blob not included in the kernel?

Because it's closed source.

> If not, why doesnt  
> the b43 driver warn in the dmesg (where Ray Lee did look) that no 
> firmware was loaded? These are basic driver usability issues, and of 
> course they are your fault too.

This is a proven false statement.

> > So new code is included in the Linux kernel based only on political 
> > considerations instead on technical?
> 
> huh? This is nothing "political". It's the basic rule of maintenance: 
> try to be a good maintainer, involve people, forgive their newbie 
> mistakes. It's like the driving principle of Intenret protocols: be 
> conservative at what you xmit and be liberal at what you rx.

That's not what my problem is here.
The problem is that every now and then people come up and say that
b43 is crap and doesn't work for them while bcm43xx does. In _every_
single case it was the user's fault. Mostly not reading the kernel
message I quoted above.

So I'm not sure what I have to do now? Defer removal of an obsolete
and unstable piece of junk because some people don't read kernel
logs in case something doesn't work?

-- 
Greetings Michael.
