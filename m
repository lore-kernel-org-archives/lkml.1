Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbXKSR1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbXKSR1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 12:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXKSR1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 12:27:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58597 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbXKSR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:27:06 -0500
Date: Mon, 19 Nov 2007 09:26:32 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Robert Gerlach <khnz@gmx.de>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fujitsu application panel driver
Message-ID: <20071119092633.42d6d6b0@freepuppy.rosehill>
In-Reply-To: <200711191350.31965.khnz@gmx.de>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
	<200711182336.59312.khnz@gmx.de>
	<20071118204307.59419579@freepuppy.rosehill>
	<200711191350.31965.khnz@gmx.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 13:50:30 +0100
Robert Gerlach <khnz@gmx.de> wrote:

> Am Montag 19 November 2007 05:43:07 schrieb Stephen Hemminger:
> > On Sun, 18 Nov 2007 23:36:58 +0100
> >
> > Robert Gerlach <khnz@gmx.de> wrote:
> > > Am Dienstag 23 Oktober 2007 21:55:55 schrieb Stephen Hemminger:
> > > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
> > > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
> > >
> > > Please make sure that this module is not autoload on Lifebook tablets (T
> > > series and P1[56]10). It works fine, but only supports a subset of
> > > features (4 of 7 buttons and no display orientation for my T4010).
> >
> > I would rather get those tablets working (with help). Rather than trying
> > to enumerate all the possible DMI values of the full range of different
> > laptops.
> 
> I've played with apanel some month ago. I've never found the keys and the 
> switch over the I2C bus. So I was starting my own module (fsc_btns) to play 
> with the IO range announced by ACPI. There I found it all. But my module 
> doesn't work on all Lifebooks (S7110 for example; has no such ACPI device).

If the device doesn't have the buttons, then the probe routine won't find them
and it should just exit and unload itself.  Now it may be too noisy right now
and it might not detect properly, if so, that is where the bug is.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
