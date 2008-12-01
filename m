Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYLALxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYLALxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLALxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:53:23 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:44899 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751068AbYLALxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:53:22 -0500
Date: Mon, 1 Dec 2008 14:53:20 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] mmc: Add mmc_vddrange_to_ocrmask() helper function
Message-ID: <20081201115320.GA10980@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru> <20081030195632.GB13640@oksana.dev.rtsoft.ru> <20081108215537.12cdf5f6@mjolnir.drzeus.cx> <20081126195417.GA26264@oksana.dev.rtsoft.ru> <20081130210648.77b8843a@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20081130210648.77b8843a@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 09:06:48PM +0100, Pierre Ossman wrote:
> On Wed, 26 Nov 2008 22:54:17 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > This function sets the OCR mask bits according to provided voltage
> > ranges. Will be used by the mmc_spi OpenFirmware bindings.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> > 
> > Hi Pierre,
> > 
> > Sorry for the delay.
> > 
> 
> This looks perfect. Just tell me when you want me to queue it up.

I plan resend the series (OF MMC SPI) some time between 2.6.28-rc0
and -rc1, that is, when all needed powerpc patches will be merged
into the Linus' tree.

Though, the $subject patch could be merged anytime as it doesn't
depend on anything else. So, if you'll merge it earlier, that will
make things a bit easier: -1 patch to resend. ;-)

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
