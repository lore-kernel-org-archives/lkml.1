Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbXE2Wf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbXE2Wf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXE2Wft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:35:49 -0400
Received: from mxfep03.bredband.com ([195.54.107.76]:53315 "EHLO
	mxfep03.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXE2Wft (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:35:49 -0400
X-Greylist: delayed 3394 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 18:35:48 EDT
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: Ian Kumlien <iank@bredband.net>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
References: <1180474738.22497.25.camel@pi.pomac.com>
	 <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 00:35:28 +0200
Message-Id: <1180478138.19814.2.camel@pi.pomac.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On ons, 2007-05-30 at 00:24 +0200, Michal Piotrowski wrote:
> Hi Ian,
> 
> (Thomas "The Wizard of Time" added to CC :))
> 
> On 29/05/07, Ian Kumlien <iank@bredband.net> wrote:
> > Hi,
> >
> > As the daystar sets, i try to play some with my new would be
> > firewall/server, but since this will be running for quite some time i
> > have been experimenting with powertop to find out what i can do to limit
> > it's power usage.
> >
> > But, if i run powertop for too long or a few times to many... this
> > happens:
> > http://pomac.netswarm.net/pics/kernel_panic.jpg
> >
> > If i don't run powertop, it is rock solid... Compiling for hours,
> > running memtest for hours etc etc...
> 
> (Where is my magic ball?)

(Lost? =))

> Let me guess - Pentium 4 with HT?

Core 2 Duo, without HT =)

> Also, please try the latest hrt tree
> http://tglx.de/projects/hrtimers/2.6.22-rc3/

If you still think i should try that, i will, this box is not in
production yet for a while so... =)

I switched to using 64 bit hpet after the last crash, will this
influence the results?

> Regards,
> Michal
> 
-- 
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net
