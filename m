Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZHLLeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZHLLeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZHLLeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:34:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39539 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZHLLeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:34:20 -0400
Date: Wed, 12 Aug 2009 13:34:20 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] [input] add mc13783 touchscreen driver
Message-ID: <20090812113419.GD17992@pengutronix.de>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-3-git-send-email-s.hauer@pengutronix.de> <20090812024609.5EB8B526EC9@mailhub.coreip.homeip.net> <20090812111018.GC17992@pengutronix.de> <20090812111646.GB11227@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812111646.GB11227@sirena.org.uk>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 13:32:22 up 6 days, 22:51, 27 users,  load average: 0.24, 1.41,
	1.27
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 12:16:46PM +0100, Mark Brown wrote:
> On Wed, Aug 12, 2009 at 01:10:18PM +0200, Sascha Hauer wrote:
> > On Tue, Aug 11, 2009 at 07:15:33PM -0700, Dmitry Torokhov wrote:
> 
> > > This device does not appear to privide pressure readings, use BTN_TOUCH
> > > alone to indicate touches instead of fake ABS_PRESSURE event. Yes, I
> > > know that older versions of tslib only recognize ABS_PRESSURE...
> 
> > In fact no released version of tslib supports this :( Anyway, fixed.
> 
> Android uses this.  No idea if they've got tslib or their own thing.
> 

tslib supports this in -trunk. Maybe I can trigger a release of tslib
soon. It's a PITA to use trunk versions with build systems.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
