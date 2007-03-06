Return-Path: <linux-kernel-owner+w=401wt.eu-S964944AbXCFLPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbXCFLPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964962AbXCFLPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:15:46 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:51081 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944AbXCFLPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:15:44 -0500
Date: Tue, 6 Mar 2007 12:17:03 +0100
From: DervishD <lkml@dervishd.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070306111703.GD25349@DervishD>
Mail-Followup-To: "Antonino A. Daplas" <adaplas@gmail.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>
References: <20070226144744.GA3615@DervishD> <1172503471.20842.14.camel@daplas> <20070226171334.GB13496@DervishD> <1172510654.7101.11.camel@daplas> <20070226203223.GA161@DervishD> <1172617755.13422.0.camel@daplas> <20070301160139.GA102@DervishD> <1173144817.7219.1.camel@daplas> <20070306062528.GF20292@DervishD> <1173164006.6285.8.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1173164006.6285.8.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Antonino :)

 * Antonino A. Daplas <adaplas@gmail.com> dixit:
> On Tue, 2007-03-06 at 07:25 +0100, DervishD wrote:
> >  * Antonino A. Daplas <adaplas@gmail.com> dixit:
> > > On Thu, 2007-03-01 at 17:01 +0100, DervishD wrote:
> > > >  * Antonino A. Daplas <adaplas@gmail.com> dixit:
> > > > > Can you try this patch?  It might help with the screen
> > > > > corruption.
> > > > 
> > > >     With the patch, the scroll slows to a crawl and the system is
> > > >     unusable. The time to scroll 30 lines is about a minute or so
> > > >     (probably more, I just measured for a while).
> > > > 
> > > >     If you want me to test other patches, just tell :)
> > > 
> > > Can you change the mdelay to udelay and use higher/lower delay values
> > > to see if there's any improvement?
> > 
> >     Yes, as soon as I can build a new kernel and reboot. Any suggested
> > value?
> 
> You can start with 5 and increment by 5.  So you need not reboot each
> time, compile tdfxfb as a module, and set CONFIG_HW_CONSOLE_BINDING=y
> (under drivers->char).

    I've done that for testing, but I haven't build that kernel yet (not
spare time by now).

> Make sure you have vbetool, and use the attached script.

    I don't have vbetool, but I'll get it.
 
> The script assumes vbetool is in /usr/sbin, if not just edit. Also,
> unbinding will only work if X (or any graphics app, for that matter) is
> not loaded.

    No problem, it will be off while I test. I'll try to make the tests
probably this friday or the weekend, as soon as I can.

    Thanks a lot for your interest :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
