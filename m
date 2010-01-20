Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326Ab0ATPaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0ATPaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694Ab0ATPad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:30:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50365 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0ATPad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:30:33 -0500
Date: Wed, 20 Jan 2010 16:30:27 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: git pre-commit hook running checkpatch.pl
Message-ID: <20100120153027.GB20271@pengutronix.de>
References: <20100120020202.GE26562@trinity.fluff.org> <20100120100155.GA851@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100120100155.GA851@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:01:55AM +0000, Mark Brown wrote:
> On Wed, Jan 20, 2010 at 02:02:02AM +0000, Ben Dooks wrote:
> 
> > I've written a git pre-commit[1] hook which stops any commits happening if
> > checkpatch.pl reports problems with the patch. Any comments?
> 
> > [1] http://www.fluff.org/ben/linux/githooks/pre-commit
> 
> Checkpatch does sometimes generate the occasional false positive which
> can be annoying when they trigger.  It can also be a problem when doing
> bugfixes IME - if an existing file has lots of checkpatch issues then a
> fix which maintains the same coding style as the surrounding code can
> trigger checkpatch issues which would if fixed make the code not fit in
> with the rest of the file.  Obviously it'd be desirable to fix the file
> but that's a bit unreasonable for people submitting bug fixes,
> especially when pushing fixes to Linus and stable.
> 
> That said, monitoring for checkpatch issues is useful.
Maybe only print the warnings instead of stopping a commit?  I'd not
like me stopping here not only for the reasons pointed out by Mark and
Russell, but also as I frequently do wip-commits that not necessarily
are checkpatch-clean.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
