Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab0BLIwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:52:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0BLIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:52:43 -0500
Date: Fri, 12 Feb 2010 09:52:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       Paul Gortmaker <p_gortmaker@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH RESEND] rtc/hctosys: only claim the RTC
	provided  the system time if it did
Message-ID: <20100212085231.GA21947@pengutronix.de>
References: <1265663419-10165-1-git-send-email-u.kleine-koenig@pengutronix.de> <1265885549-23920-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100211115700.12853990@linux.lan.towertech.it> <20100211144240.8fbec55e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100211144240.8fbec55e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Thu, Feb 11, 2010 at 02:42:40PM -0800, Andrew Morton wrote:
> On Thu, 11 Feb 2010 11:57:00 +0100
> Alessandro Zummo <a.zummo@towertech.it> wrote:
> 
> > On Thu, 11 Feb 2010 11:52:29 +0100
> > Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:
> > 
> > 
> > > Signed-off-by: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> > > ---
> > > Hello,
> > > 
> > > this time the patch is complete.
> > > 
> > > What do you think about it?
> 
> I do dislike having to trawl through the patch trying to work out what
> the changelog forgot to tell me.
> 
> What problem is being fixed here?
> 
> What is the user-observable manifestation of that problem?
> 
> How does the patch fix it?
> 
> Stuff like that!
What do you think about:

---->8----
rtc/hctosys: only claim the RTC provided the system time if it did

Without this patch /sys/class/rtc/$CONFIG_RTC_HCTOSYS_DEVICE/hctosys
contains a 1 (meaning "This rtc was used to initialize the system
clock") even if reading the time at bootup failed.

Moreover change error handling in rtc_hctosys() to use goto and so
reduce the indention level.
---->8----

> >  looks nice but I'll have to give a deeper look.
> >  will probably queue for the next merge window
> 
> I merged it with a "needs Alessandro ack" note-to-self.
fine, thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
