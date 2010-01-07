Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066Ab0AGIiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0AGIiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584Ab0AGIiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:38:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45547 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab0AGIiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:38:15 -0500
Date: Thu, 7 Jan 2010 09:37:29 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
       David Woodhouse <dwmw2@infradead.org>, Nicolas Pitre <nico@marvell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd/nand: Fix build failure caused by typo
Message-ID: <20100107083729.GB7413@pengutronix.de>
References: <201001070301.58260.PeterHuewe@gmx.de> <BD79186B4FD85F4B8E60E381CAEE1909020894AF@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909020894AF@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > This patch fixes a build failure[1] introduced by the patch
> >     mtd: orion_nand.c: add error handling and use resource_size()
> >     by H Hartley Sweeten [2]
> > The patch assigns something to a undeclared variable 'err', whereas the
> > rest of the code uses 'ret' for this task.
> > 
> > This patch fixes this typo and thus removes the build failure.
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
