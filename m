Return-Path: <linux-kernel-owner+w=401wt.eu-S1765046AbXLNLmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765046AbXLNLmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLNLmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:42:44 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:43457 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXLNLmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:42:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 12:39:51 +0100
User-Agent: KMail/1.9.6
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com, mbuesch@freenet.de,
       John Linville <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712141149.46945.mb@bu3sch.de> <20071214111534.GD23964@elte.hu>
In-Reply-To: <20071214111534.GD23964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141239.51809.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 12:15:34 Ingo Molnar wrote:
> > So you volunteer to maintain bcm43xx? Fine. Thanks a lot.
> 
> it's sad that you are trying to force testers to upgrade to your new 
> driver by threatening to unsupport the old driver.

I dropped maintainance for bcm43xx over a year ago.
So I am not going to catch it up again. b43 works fine.
I don't see a reason to support bcm43xx anymore.
Currently bcm43xx is orphaned, as Larry couldn't support it
anymore due to other issues.

> The testers who did  
> nothing but reported that the new driver did not work on their hardware.

Which testers?
Ray Lee didn't even install the firmware. So it can't work by definition.
That is not my fault.

> You can write new drivers but you must not break existing users. That's 
> true for every single piece of the kernel. It is _your_ responsibility 
> to get that rule right - and if it does not work out of box (no matter 
> whom to blame, udev or the driver) you dont get to remove the driver 
> from the upstream kernel.

Ok. So we have to live with an orphaned driver. I am fine with that, too.

> Yes, you can then "unsupport it" in spite and be a prick about it in 
> general but that will only talk of your own personal qualities and will 
> sharply reduce your credibility as a maintainer (and eventually hinder 
> your ability to introduce new code) - users will still have the code 
> available and will have a chance to fix the driver that happens to work. 
> (and perhaps another, capable, but friendler maintainer arises.) And 
> that old code will be a clot to drag around, hindering your 'new' 
> wireless code all along.

So new code is included in the Linux kernel based only on political
considerations instead on technical?
I'm not sure what's the matter. Show me _one_ person for whom
bcm43xx works and b43/legacy does not. And I will immediately stop
removal of that driver and fix b43.

> I really dont know why it's so hard to understand: new is totally 
> useless if it does not work for old setups 100% of the time. And people 
> _WANT_ to use your new code, so it's not like you have to pull their 
> hairs to get your stuff tested. And YOU wrote the old code in large 
> part:
> 
>  $ git-authors drivers/net/wireless/bcm43xx/ | tail -10
>       2  Sam Ravnborg
>       3  David Howells
>       3  David Woodhouse
>       3  Joe Perches
>       4  Jeff Garzik
>       5  Daniel Drake
>       6  Stefano Brivio
>       9  John W. Linville
>      48  Larry Finger
>      80  Michael Buesch
> 
> so it's not like "someone else messed it up" and that you would be 
> incapable of getting it all work nicely and make the migration of users 
> smoother. And if udev is a hindrance to you, reduce your driver's 
> dependence on udev breakages.

I'm not sure what you are talking about.
If udev renames the device to something stupid (like wlan0_rename)
that is not my fault. That is the fault of a big Linux Distribution
messing udev config up.

Let's summarise it:
I don't know a single user for whom bcm43xx works but b43 does not.
In most cases b43 does work a _lot_ better than bcm43xx.
If you show me one person for whom bcm43xx works but b43 does not I
will stop removal of the driver.

-- 
Greetings Michael.
