Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbZJAFAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbZJAFAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 01:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZJAFAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 01:00:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46899 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZJAFAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 01:00:37 -0400
Date: Thu, 1 Oct 2009 06:59:45 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       s.hauer@pengutronix.de, g.liakhovetski@gmx.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Updates for spi-imx
Message-ID: <20091001045945.GA30932@pengutronix.de>
References: <20090930194211.GB1881@pengutronix.de> <20090930165241.ecb2a83e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090930165241.ecb2a83e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, Sep 30, 2009 at 04:52:41PM -0700, Andrew Morton wrote:
> On Wed, 30 Sep 2009 21:42:11 +0200
> Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:
> 
> > as a followup to this mail I'll send some updates for the spi-imx
> > driver for review.
> 
> Several of these patches were unchangelogged but afaict they all fix
> bugs and hence should be in 2.6.32, yes?
I'm not sure about "strip down chipselect function to only drive the
chipselect", that's why I marked it RFC.  I see the driver working with
it and using less register writes, but if someone would check it and
consider it OK, I'd feel better. 

"spi-imx: no need to assert bits_per_word being initialized" isn't a
real bugfix, it just removes an if(...) that is never hit.

The other (non-naughty) patches are bugfixes, yes.
 
> Renaming the entire source file after -rc1 was probably a bit naughty,
> but we'll survive.
I didn't target for 2.6.32, I just wanted to get rid of the patches.
The earlier they get in the better for me.

To be honest I expected to get back some patches because of the missing
changelog.  I just wanted to get them out before going to bed.

Best regards and thanks for picking my patches up
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
