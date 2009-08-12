Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbZHLLQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbZHLLQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932555AbZHLLQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:16:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51488 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbZHLLQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:16:48 -0400
Date: Wed, 12 Aug 2009 12:16:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] [input] add mc13783 touchscreen driver
Message-ID: <20090812111646.GB11227@sirena.org.uk>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-3-git-send-email-s.hauer@pengutronix.de> <20090812024609.5EB8B526EC9@mailhub.coreip.homeip.net> <20090812111018.GC17992@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812111018.GC17992@pengutronix.de>
X-Cookie: One FISHWICH coming up!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:10:18PM +0200, Sascha Hauer wrote:
> On Tue, Aug 11, 2009 at 07:15:33PM -0700, Dmitry Torokhov wrote:

> > This device does not appear to privide pressure readings, use BTN_TOUCH
> > alone to indicate touches instead of fake ABS_PRESSURE event. Yes, I
> > know that older versions of tslib only recognize ABS_PRESSURE...

> In fact no released version of tslib supports this :( Anyway, fixed.

Android uses this.  No idea if they've got tslib or their own thing.
