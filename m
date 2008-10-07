Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYJGW1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYJGW1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYJGW0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:26:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55939 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbYJGW0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:26:51 -0400
Date: Wed, 8 Oct 2008 00:28:29 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: Auke@suse.cz, " <auke-jan.h.kok@intel.com>"@suse.cz,
       linux-kernel@vger.kernel.org, rjwysocki@sisk.pl,
       power-management_other@kernel-bugs.osdl.org
Subject: Re: [Bug 10797] Battery is drained after poweroff
Message-ID: <20081007222829.GT6604@elf.ucw.cz>
References: <20494.201.3.158.14.1223417777.mandic:mail - neo@webmail.mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20494.201.3.158.14.1223417777.mandic:mail - neo@webmail.mandic.com.br>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>>> ...and it is not linux problem because it works okay on my thinkpad. See?
> >>>
> >>> Yes, this is a Linux problem (at least in release >= 2.6.22)
> >>> This happening *only* in Linux (Kernel >=2.6.22).
> >>
> >> Wow, now that's useful info.
> 
> I don´t comment this before because we already said this in bug reports
> (links above).

Sorry about that. lkml has rather big traffic.

> >> I guess you _could_ do git bisect? ;-).
> 
> So sorry, but I really don´t now how can I do this.
> I´m an user, not developer. Can you send me a "how-to" about git
> bisect?

http://kerneltrap.org/node/11753

There may be better HOWTOs around.

> >>> And is impossible find wich device eats power (eaten current is too low,
> >>> and is not enought to make hot).
> >>
> >> So how fast is it eating power... can you estimate Watts eaten?
> 
> Eaten ~5% of battery each 10h.

Lets assume 40Wh battery... 0.5% per hour... that means 200 hours to
empty. 0.5% per hour is 40 * 0.005 Wh/h = 0.2 W AFAICT... hmm, that's
quite low. Debugging this will not be easy :-(.
									Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
