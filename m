Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab0BCU44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:56:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58028 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab0BCU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:56:55 -0500
Date: Wed, 3 Feb 2010 21:56:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MX1/MX2: -EINVAL overwritten in second iteration in
	mxc_gpio_setup_multiple_pins()
Message-ID: <20100203205609.GG20113@pengutronix.de>
References: <4B69CC24.3050503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B69CC24.3050503@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 08:19:00PM +0100, Roel Kluin wrote:
> Due to the `ret = gpio_request()' below in the loop, the initial -EINVAL value
> of ret is overwritten. 
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

> ---
> Not 100% sure this is needed, please review. One more question: is it ok
> to return 0 when count is 0 (and nothing is done)?
I'd say yes.  If you want nothing from me, I can say I gave you all you
wanted without doing anything.

Thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
