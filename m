Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab0BKUHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:07:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50694 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab0BKUHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:07:10 -0500
Date: Thu, 11 Feb 2010 21:07:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution
	timer and a GPIO pin
Message-ID: <20100211200702.GB1487@ucw.cz>
References: <cover.1265094517.git.bgat@billgatliff.com> <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static void
> +gpio_pwm_work (struct work_struct *work)
> +{
> +	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
> +
> +	if (gp->active)
> +		gpio_direction_output(gp->gpio, gp->polarity ? 1 : 0);
> +	else
> +		gpio_direction_output(gp->gpio, gp->polarity ? 0 : 1);
> +}

...polarity ^ active ?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
