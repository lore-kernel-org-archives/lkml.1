Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYJGS6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYJGS6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYJGS6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:58:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52336 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYJGS6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:58:32 -0400
Date: Tue, 7 Oct 2008 21:00:07 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org, rjwysocki@sisk.pl,
       power-management_other@kernel-bugs.osdl.org
Subject: Re: [Bug 10797] Battery is drained after poweroff
Message-ID: <20081007190007.GB6604@elf.ucw.cz>
References: <48E9F388.8040203@diamondcut.com.br> <20081007134223.GA1592@ucw.cz> <48EB88F2.3090100@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EB88F2.3090100@diamondcut.com.br>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-07 13:06:10, Renato S. Yamane wrote:
> Pavel Machek wrote:
> Renato S. Yamane wrote:
> >> Can someone help us with this bug?
> >> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> >>
> >> Same problem is reported in Ubuntu:
> >> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>
> >>
> >> This is not a hardware problem, because if the same laptop is poweroff
> >> by Windows, battery charge don't change.
> > 
> > ...and it is not linux problem because it works okay on my thinkpad. See? 
> 
> Yes, this is a Linux problem (at least in release >= 2.6.22)
> This happening *only* in Linux (Kernel >=2.6.22).

Wow, now that's useful info.

I guess you _could_ do git bisect? ;-).

> >> And, if I suspend to ram/disk BEFORE poweroff, battery charge don't
> >> change (suspend to ram/disk --> WakeUp --> Poweroff).
> > 
> > Which machine is that? Can you find out which device eats power? (It
> > should be warm).
> 
> This problem is happening in Toshiba Satellite M45-S355, Toshiba Equium
> A100-306, HP DV8000, HP DV9500, Dell Latitude D630, Toshiba M110, Sony
> Vaio VGN-S2XP, Toshiba Satellite A105-S4384, Toshiba Satellite M55-S3314
> and Toshiba Satellite A105-S2201 as you can see in bug report listed above.
> 
> And is impossible find wich device eats power (eaten current is too low,
> and is not enought to make hot).

So how fast is it eating power... can you estimate Watts eaten?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
