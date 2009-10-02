Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZJBVDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZJBVDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbZJBVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:03:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZJBVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:03:43 -0400
Date: Fri, 2 Oct 2009 23:03:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, thommycheck@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       utx@penguin.cz, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, eric.y.miao@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: 2.6.32-rc1: spitz boots but suspend/resume is broken
Message-ID: <20091002210341.GD29734@elf.ucw.cz>
References: <20090930120655.GG1412@ucw.cz> <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com> <20091002041015.GB1409@ucw.cz> <20091002073205.GA23986@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002073205.GA23986@pengutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-10-02 09:32:05, Sascha Hauer wrote:
> Hi,
> 
> On Fri, Oct 02, 2009 at 06:10:15AM +0200, Pavel Machek wrote:
> > On Wed 2009-09-30 16:09:25, Dmitry Eremin-Solenikov wrote:
> > > On Wed, Sep 30, 2009 at 4:06 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > > > Hi!
> > > >
> > > > matrix keyboard driver needs to be enabled, otherwise it seems ok.
> > > >
> > > > Unfortunately, it does not respond to power button in any visible way
> > > > :-(. Any ideas what might be wrong/how to debug it?
> > > 
> > > Enable gpio-keyboard driver, verify (or port power button to it :))
> > > and check that
> > > enable_wakeup is enabled.
> > 
> > It seems neccessary tables for gpio-keyboard just are not there :-(.
> > 
> > In the meantime, this allows easy switch to known-good driver. (Can we
> > get it upstream until problem is fixed properly?)
> > 
> > Unfortunately, that still does not fix suspend/resume. (Does it work
> > for you?)
> 
> Are you using the serial console on spitz? If yes, this might be
> interesting for you:

I don't have serial cable :(.

> http://bugzilla.kernel.org/show_bug.cgi?id=14297
> 
> I ended up with a console with 9600 baud after resume. My system resumed
> correctly, but I did not see anything.

...but someone with serial cable capturing 2.6.32-rc2 resume would
certainly be welcome :).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
