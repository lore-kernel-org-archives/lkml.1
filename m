Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYKQL5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYKQL5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 06:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYKQL5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 06:57:15 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4353 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYKQL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:57:14 -0500
Date: Mon, 17 Nov 2008 11:57:09 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add WM8350 LED driver
Message-ID: <20081117115709.GF1559@sirena.org.uk>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081114151908.0af38e4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114151908.0af38e4c.akpm@linux-foundation.org>
X-Cookie: I'm into SOFTWARE!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 03:19:08PM -0800, Andrew Morton wrote:

> > +	led_classdev_unregister(&led->cdev);
> > +	schedule_work(&led->work);
> > +	flush_scheduled_work();

> The schedule_work() is unexpected and I can't immediately see why it's
> here.  If it is indeed correct, I'd suggest the addition of a comment.

Me either, I'll remove it and fix the other things you raised too.
Thanks.
