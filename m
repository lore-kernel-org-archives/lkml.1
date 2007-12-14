Return-Path: <linux-kernel-owner+w=401wt.eu-S933070AbXLNMRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbXLNMRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932783AbXLNMRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:17:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbXLNMRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:17:23 -0500
Date: Fri, 14 Dec 2007 13:16:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com, mbuesch@freenet.de,
       John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071214121617.GE23964@elte.hu>
References: <20071213003028.676998182@mvista.com> <200712141149.46945.mb@bu3sch.de> <20071214111534.GD23964@elte.hu> <200712141239.51809.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712141239.51809.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Buesch <mb@bu3sch.de> wrote:

> > The testers who did nothing but reported that the new driver did not 
> > work on their hardware.
> 
> Which testers?

right in this thread Ray Lee is reporting:

| | Digging a little farther into it, it looks like b43 is barfing 
| | partway through init as the firmware file it's looking for has 
| | changed names. Perhaps that's the issue. I'll take a longer look at 
| | this all tomorrow.

you are really in denial of reality. Just re-read this thread. Upon 
re-reading this thread, try to imagine that you are in place of Ray Lee 
(might be hard), that you had a working bcm43xx driver and that now you 
try to get b43 to work. You are not a kernel hacker who knows this 
driver, just an advanced user who'd like to give you some more feedback 
about your shiny new code. From that perspective, do you think your 
replies were fine, constructive and involved the tester? I sure read 
them as dismissive, they had an annoyed tone (i'm not sure why - he was 
trying to get _YOUR_ code to work) and were borderline arrogant. Looking 
at the replies from Ray Lee it sure seemed to me he had a similar 
impression. In place of Ray Lee, would you report new bugs to the 
maintainer of b43? I sure as hell would avoid it if i could. Do you 
think such incidents help Linux in the long run?

and you even claim:

> Ray Lee didn't even install the firmware. So it can't work by 
> definition. That is not my fault.

which questions your basic skills of reading or of empathy. Why is a 
reasonable firmware blob not included in the kernel? If not, why doesnt 
the b43 driver warn in the dmesg (where Ray Lee did look) that no 
firmware was loaded? These are basic driver usability issues, and of 
course they are your fault too.

> > Yes, you can then "unsupport it" in spite and be a prick about it in 
> > general but that will only talk of your own personal qualities and 
> > will sharply reduce your credibility as a maintainer (and eventually 
> > hinder your ability to introduce new code) - users will still have 
> > the code available and will have a chance to fix the driver that 
> > happens to work. (and perhaps another, capable, but friendler 
> > maintainer arises.) And that old code will be a clot to drag around, 
> > hindering your 'new' wireless code all along.
>
> So new code is included in the Linux kernel based only on political 
> considerations instead on technical?

huh? This is nothing "political". It's the basic rule of maintenance: 
try to be a good maintainer, involve people, forgive their newbie 
mistakes. It's like the driving principle of Intenret protocols: be 
conservative at what you xmit and be liberal at what you rx.

	Ingo
