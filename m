Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbXKSEp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbXKSEp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 23:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXKSEpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 23:45:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbXKSEps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 23:45:48 -0500
Date: Sun, 18 Nov 2007 20:43:07 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Robert Gerlach <khnz@gmx.de>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fujitsu application panel driver
Message-ID: <20071118204307.59419579@freepuppy.rosehill>
In-Reply-To: <200711182336.59312.khnz@gmx.de>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
	<200709161623.00286.dtor@insightbb.com>
	<20071023125555.38d63567@shemminger-laptop>
	<200711182336.59312.khnz@gmx.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 23:36:58 +0100
Robert Gerlach <khnz@gmx.de> wrote:

> Am Dienstag 23 Oktober 2007 21:55:55 schrieb Stephen Hemminger:
> > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
> > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
> 
> Please make sure that this module is not autoload on Lifebook tablets (T 
> series and P1[56]10). It works fine, but only supports a subset of features 
> (4 of 7 buttons and no display orientation for my T4010).
> 
> Thanks,
>   Robert

I would rather get those tablets working (with help). Rather than trying
to enumerate all the possible DMI values of the full range of different laptops.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
