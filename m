Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbZFNLi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbZFNLi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZFNLiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:38:21 -0400
Received: from kroah.org ([198.145.64.141]:51323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbZFNLiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:38:21 -0400
Date: Sun, 14 Jun 2009 04:28:02 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Thomas Gleixner <tglx@linutronix.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
Message-ID: <20090614112802.GA4502@kroah.com>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 11:38:38PM +0200, Uwe Kleine-König wrote:
> I know that at least COMEDI and RT2870 are broken with -rt,

I didn't know this, has anyone sent me a bug report?  What in -rt causes
these drivers to break?

> but Thomas requested disabling all of staging.  He's the maintainer.

This seems like a patch to ensure that the staging drivers never get a
chance to be fixed for any potential -rt issues.  How about just sending
me bug reports instead?

thanks,

greg k-h
