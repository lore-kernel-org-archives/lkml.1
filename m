Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZJUN5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZJUN5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 09:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZJUN5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 09:57:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60556 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZJUN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 09:57:06 -0400
Date: Wed, 21 Oct 2009 15:56:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial/atmel_serial: Fix another fallout of the change
	to BUILD_BUG_ON
Message-ID: <20091021135653.GA2064@pengutronix.de>
References: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091013092644.72c78334@hskinnemoen-d830> <20091013082447.GA3194@pengutronix.de> <20091021122709.GA332@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091021122709.GA332@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 21, 2009 at 01:27:09PM +0100, Russell King - ARM Linux wrote:
> On Tue, Oct 13, 2009 at 10:24:47AM +0200, Uwe Kleine-König wrote:
> > Hello Andrew,
> > 
> > On Tue, Oct 13, 2009 at 09:26:44AM +0200, Haavard Skinnemoen wrote:
> > > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > > > Commit 8c87df457cb5 fixed BUILD_BUG_ON with the result that some
> > > > expressions (e.g. "not really constant" ones) result in a build failure.
> > > > 
> > > > Some of these were fixed in 8c87df457cb5, but not serial/atmel_serial.
> > > 
> > > This patch fixes the same issue:
> > > 
> > > http://lkml.org/lkml/2009/10/6/305
> > Can you please take this and add my Ack?
> > 
> > If you cannot find it anymore in your inbox, you can get it from
> > http://article.gmane.org/gmane.linux.kernel/898575/raw
> 
> So what's happening with this?
The patch by Haavard Skinnemoen is in -mm as

	atmel_serial-fix-bad-build_bug_on-usage.patch

.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
