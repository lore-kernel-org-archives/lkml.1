Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab0CBIyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:54:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42245 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0CBIyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:54:17 -0500
Date: Tue, 2 Mar 2010 09:54:12 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       linux-input@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Luotao Fu <l.fu@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/6] input/mc13783-ts: Don't use deprecated mc13783 API
	calls
Message-ID: <20100302085412.GC17629@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de> <1267440825-14694-2-git-send-email-u.kleine-koenig@pengutronix.de> <20100302075513.GC17307@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100302075513.GC17307@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 11:55:13PM -0800, Dmitry Torokhov wrote:
> On Mon, Mar 01, 2010 at 11:53:41AM +0100, Uwe Kleine-König wrote:
> > mc13783_ackirq is deprecated, use the drop in replacement mc13783_irq_ack.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> I assume it will go thourgh MFD tree?
I don't know.  I would have suggest to let it go via Andrew[1] as the
biggest changes in this series are rtc related and these usually go via
him.  But MFD would be OK for me, too.

Best regards
Uwe

[1] hmm, forgot to Cc: him.  This is done now.

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
