Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYANLGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYANLGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYANLGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:06:44 -0500
Received: from smtp1.int-evry.fr ([157.159.10.44]:48241 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbYANLGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:06:44 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [RFC, PATCH, take 2] watchdog on generic gpio
Date: Mon, 14 Jan 2008 12:06:38 +0100
User-Agent: KMail/1.9.7
Cc: wim@iguana.be, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Mike Frysinger" <vapier.adi@gmail.com>
References: <200801141103.23744.marc.pignat@hevs.ch>
In-Reply-To: <200801141103.23744.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801141206.39858.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

Le lundi 14 janvier 2008, Marc Pignat a écrit :
> +static int gpio_wdt_keepalive(struct gpio_wdt *wdt)
> +{
> +	gpio_set_value(wdt->pdata->pin, 0);
> +	gpio_set_value(wdt->pdata->pin, 1);
> +	return 0;
> +}

I would like this function to be supplied by the platform_data structure 
because as I mentioned before, not all GPIO connected watchdog will simply 
need a single bit to be toggled, but also sometimes a full GPIO line.

If we do not supply any specific callback to keepalive the watchdog let's just 
assume we need a single bit to be toggled if this is ok with you ?

Thank you !
-- 
Cordialement, Florian Fainelli
------------------------------
