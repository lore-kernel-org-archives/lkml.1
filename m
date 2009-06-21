Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZFUGou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZFUGou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 02:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZFUGom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 02:44:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41553 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZFUGol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 02:44:41 -0400
Date: Sun, 21 Jun 2009 08:39:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Further document parameters for blink_set()
Message-ID: <20090621063936.GA1656@ucw.cz>
References: <1244726268-1517-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244726268-1517-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 14:17:48, Mark Brown wrote:
> The documentation for the parameters of blink_set() was a bit hard
> to find so put some where I'd expected to find it.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/leds.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 376fe07..c7f0b14 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -45,7 +45,9 @@ struct led_classdev {
>  	/* Get LED brightness level */
>  	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
>  
> -	/* Activate hardware accelerated blink */
> +	/* Activate hardware accelerated blink, delays are in
> +	 * miliseconds and if none is provided then a sensible default
> +	 * should be chosen. */
>  	int		(*blink_set)(struct led_classdev *led_cdev,
>  				     unsigned long *delay_on,
>  				     unsigned long *delay_off);

What a strange calling convention. Does it return data in
*delay_on/off ? Should that also be documented?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
