Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927Ab0AMLRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0AMLRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551Ab0AMLRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:17:07 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46571 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755646Ab0AMLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:17:06 -0500
Date: Wed, 13 Jan 2010 14:17:03 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [RESEND PATCH 5/5] spi/mpc8xxx: don't check platform_get_irq's
 return value against zero
Message-ID: <20100113111702.GA5004@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1263380746-27803-5-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1263380746-27803-5-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 12:05:46PM +0100, Uwe Kleine-König wrote:
> platform_get_irq returns -ENXIO on failure, so !irq was probably
> always true.  Make irq a signed variable and compare irq <= 0.  Note
> that a return value of zero is still handled as error even though this
> could mean irq0.
> 
> This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> changed the return value of platform_get_irq from 0 to -ENXIO on error.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: David Vrabel <dvrabel@arcom.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: spi-devel-general@lists.sourceforge.net
> ---

Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Thanks!
