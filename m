Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZJBHcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZJBHcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZJBHcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:32:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40934 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZJBHcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:32:05 -0400
Date: Fri, 2 Oct 2009 09:32:05 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, thommycheck@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       utx@penguin.cz, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, eric.y.miao@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: 2.6.32-rc1: spitz boots but suspend/resume is broken
Message-ID: <20091002073205.GA23986@pengutronix.de>
References: <20090930120655.GG1412@ucw.cz> <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com> <20091002041015.GB1409@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002041015.GB1409@ucw.cz>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:29:52 up 14 days, 21:45, 47 users,  load average: 0.04, 0.14,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 02, 2009 at 06:10:15AM +0200, Pavel Machek wrote:
> On Wed 2009-09-30 16:09:25, Dmitry Eremin-Solenikov wrote:
> > On Wed, Sep 30, 2009 at 4:06 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > > Hi!
> > >
> > > matrix keyboard driver needs to be enabled, otherwise it seems ok.
> > >
> > > Unfortunately, it does not respond to power button in any visible way
> > > :-(. Any ideas what might be wrong/how to debug it?
> > 
> > Enable gpio-keyboard driver, verify (or port power button to it :))
> > and check that
> > enable_wakeup is enabled.
> 
> It seems neccessary tables for gpio-keyboard just are not there :-(.
> 
> In the meantime, this allows easy switch to known-good driver. (Can we
> get it upstream until problem is fixed properly?)
> 
> Unfortunately, that still does not fix suspend/resume. (Does it work
> for you?)

Are you using the serial console on spitz? If yes, this might be
interesting for you:

http://bugzilla.kernel.org/show_bug.cgi?id=14297

I ended up with a console with 9600 baud after resume. My system resumed
correctly, but I did not see anything.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
