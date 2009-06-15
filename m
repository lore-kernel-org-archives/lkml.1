Return-Path: <linux-kernel-owner+w=401wt.eu-S1763297AbZFORHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297AbZFORHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbZFORG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:06:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58611 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbZFORG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:06:59 -0400
Date: Mon, 15 Jun 2009 19:06:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090615170655.GF25040@elf.ucw.cz>
References: <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com> <4A32D079.9030707@mnementh.co.uk> <a55d774e0906121527n16019225q81084945a38bb97e@mail.gmail.com> <20090612223141.GF17688@elf.ucw.cz> <a55d774e0906121536m41715207td0cab3ba41d03bf2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906121536m41715207td0cab3ba41d03bf2@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Actually I agree with Brian here, this is better done at kernel level.
> >
> > OTOH, at least initially, it does not need to be done at all. It will
> > make battery readings less reliable but hey... the battery meter does
> > not work reliably anyway and estimating capacity left from voltage
> > acceptably on other platforms...
> 
> I'd agree.  This stuff can wait until the core support is solid.  I'd
> fight harder for conditional support for wakelocks since that has a
> much bigger impact on battery life (being able to know when it's safe
> to power collapse in idle, etc), whereas this just improves the
> accuracy of the battery gauging.

Yes, wakelocks are more important than battery gauging... but they
need core support :-(; and they can wait, too.

Getting serial support & board-dream upstream are very good first
steps (thanks!). I'm currently trying to get 2.6.30 + your series of 3
+ framebuffer changes to boot.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
