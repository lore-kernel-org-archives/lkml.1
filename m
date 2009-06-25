Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZFYK74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZFYK74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZFYK7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:59:49 -0400
Received: from dan.rpsys.net ([93.97.175.187]:52043 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZFYK7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:59:48 -0400
Subject: Re: [PATCH] LED: Reply-To: use correct name for
	/sys/devices/virtual/leds/ entries
From: Richard Purdie <rpurdie@rpsys.net>
To: Greg KH <greg@kroah.com>
Cc: asdf@kroah.com, Guennadi Liakhovetski <lg@denx.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090624223343.GA17235@kroah.com>
References: <20090624223343.GA17235@kroah.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 11:57:55 +0100
Message-Id: <1245927475.6001.38.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 15:33 -0700, Greg KH wrote:
> From: Olaf Hering <olh@suse.de>
> 
> This is needed to get kde-powersave to work properly on some g4
> powerbooks.
> 
> From: Olaf Hering <olh@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

I'm ok with this apart from:

> --- a/drivers/leds/ledtrig-default-on.c
> +++ b/drivers/leds/ledtrig-default-on.c
> @@ -23,7 +23,7 @@ static void defon_trig_activate(struct l
>  }
>  
>  static struct led_trigger defon_led_trigger = {
> -	.name     = "default-on",
> +	.name     = "default::on",
>  	.activate = defon_trig_activate,
>  };

which doesn't seem to match the patch description. Why does the trigger
name need to be changed?

Cheers,

Richard


-- 
Richard Purdie
Intel Open Source Technology Centre

