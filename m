Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZFVPQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZFVPQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZFVPPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:15:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45214 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZFVPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:15:51 -0400
Date: Mon, 22 Jun 2009 17:15:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Thomas Gleixner <tglx@linutronix.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
Message-ID: <20090622151515.GA16627@pengutronix.de>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com> <20090614230044.GA21624@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090614230044.GA21624@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Jun 15, 2009 at 01:00:44AM +0200, Uwe Kleine-König wrote:
> On Sun, Jun 14, 2009 at 04:28:02AM -0700, Greg KH wrote:
> > On Sat, Jun 13, 2009 at 11:38:38PM +0200, Uwe Kleine-König wrote:
> > > I know that at least COMEDI and RT2870 are broken with -rt,
> > 
> > I didn't know this, has anyone sent me a bug report?  What in -rt causes
> > these drivers to break?
> > 
> > > but Thomas requested disabling all of staging.  He's the maintainer.
> > 
> > This seems like a patch to ensure that the staging drivers never get a
> > chance to be fixed for any potential -rt issues.  How about just sending
> > me bug reports instead?
> I cannot reproduce the failure I saw for RT2870 at the moment.
OK, hit again:

17:02:43 E: ERROR: "there_is_no_init_MUTEX_LOCKED_for_RT_semaphores" [drivers/staging/rt2870/rt2870sta.ko] undefined!

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
