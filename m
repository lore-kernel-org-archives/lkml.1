Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXKSMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXKSMuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXKSMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:50:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:58953 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752444AbXKSMul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:50:41 -0500
X-Authenticated: #24222693
X-Provags-ID: V01U2FsdGVkX1/YVk0+ShrYYsl/oCk72a+BOe85V/Mf8AhV9XrmKC
	ItmJI1oehXmfpo
From: Robert Gerlach <khnz@gmx.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver
Date: Mon, 19 Nov 2007 13:50:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dmitry Torokhov <dtor@insightbb.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <200711182336.59312.khnz@gmx.de> <20071118204307.59419579@freepuppy.rosehill>
In-Reply-To: <20071118204307.59419579@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191350.31965.khnz@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 19 November 2007 05:43:07 schrieb Stephen Hemminger:
> On Sun, 18 Nov 2007 23:36:58 +0100
>
> Robert Gerlach <khnz@gmx.de> wrote:
> > Am Dienstag 23 Oktober 2007 21:55:55 schrieb Stephen Hemminger:
> > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
> > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
> >
> > Please make sure that this module is not autoload on Lifebook tablets (T
> > series and P1[56]10). It works fine, but only supports a subset of
> > features (4 of 7 buttons and no display orientation for my T4010).
>
> I would rather get those tablets working (with help). Rather than trying
> to enumerate all the possible DMI values of the full range of different
> laptops.

I've played with apanel some month ago. I've never found the keys and the 
switch over the I2C bus. So I was starting my own module (fsc_btns) to play 
with the IO range announced by ACPI. There I found it all. But my module 
doesn't work on all Lifebooks (S7110 for example; has no such ACPI device).

Do you think it is wise to merge apanel and fsc_btns? I think it's too 
different.

Robert


PS: I've no informations or specs from Fujitsu Siemens, so this can be totally 
wrong.

