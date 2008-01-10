Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYAJROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYAJROm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYAJROf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:14:35 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:50494 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754079AbYAJROe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:14:34 -0500
Date: Thu, 10 Jan 2008 17:14:22 +0000
From: Ben Dooks <ben@fluff.org>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] watchdog on gpio
Message-ID: <20080110171422.GA27399@fluff.org.uk>
References: <200801101611.08867.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801101611.08867.marc.pignat@hevs.ch>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 04:11:08PM +0100, Marc Pignat wrote:
> watchdog driver for embedded systems with a supervisor watchdog (MAX823 or so)
> connected to a gpio. This is the platform_driver and needs platform_data for
> defining the gpio pin and the watchdog timeout.
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> ---
> 
> Hi!
> 
> If you've got a max823, 824 or any cpu supervisor like this connected to your
> cpu by a gpio pin, you can use this watchdog driver.
> 
> Simply add this to your board specific setup file:
> 
> #include <linux/gpio_wdt.h>
> 
> static struct gpio_wdt_pdata my_wdt = {
> 	/* WDI input connected to this gpio */
> 	.pin		= AT91_PIN_PD27,
> 	/* The *min* timeout */
> 	.timeout_ms	= 1140
> };
> 
> static struct platform_device my_watchdog_device =
> {
> 	.name = GPIO_WDT_DRIVER_NAME,
> 	.id   = 0,
> 	.dev  =	{
> 		.platform_data=&my_wdt,

minor style problem here, ".platform_data = &my_wdt"

[snip]

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
