Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYFYLBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYFYLBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYFYLBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:01:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56328 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbYFYLBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:01:34 -0400
Date: Wed, 25 Jun 2008 12:23:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
Subject: [regression] Re: 2.6.26-rc6: pcmcia stopped working
Message-ID: <20080625102347.GA2011@elf.ucw.cz>
References: <20080622224022.GA2066@elf.ucw.cz> <20080623081309.GA10820@isilmar.linta.de> <20080623081811.GA1850@elf.ucw.cz> <20080623083046.GA12849@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623083046.GA12849@isilmar.linta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-23 10:30:46, Dominik Brodowski wrote:
> On Mon, Jun 23, 2008 at 10:18:11AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > After s2ram and resume, CF card in PCMCIA-to-CF slot is no longer
> > > > detected.
> > > 
> > > might this be related to:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10957 ? There didn't change
> > > anything with regard to pcmcia between -rc3 and -rc6...
> > 
> > I'm pretty sure it worked in 2.6.25; I don't know if it worked in
> > -rc3, or not.
> > 
> > I don't even see note about card insertion in dmesg, so I figured out
> > it is probably pcmcia-core problem (or something deeper).
> 
> Well, even since 2.6.25 not much changed in PCMCIA-land, so...

Actually, it is worse. On thinkpad, PCMCIA card is only detected
once. If I remove it and reinsert it, it will not be detected, and
machine will not reboot.

Thinkpad X60.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
