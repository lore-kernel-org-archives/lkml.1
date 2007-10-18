Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbXJRVpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbXJRVpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbXJRVpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:45:12 -0400
Received: from main.gmane.org ([80.91.229.2]:43415 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbXJRVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:45:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Thu, 18 Oct 2007 17:38:28 -0400
Message-ID: <20071018173828.159b15dd@ephemeral>
References: <200710181551.24912.florian.fainelli@telecomint.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-65-96-190-138.hsd1.ma.comcast.net
In-Reply-To: <200710181551.24912.florian.fainelli@telecomint.eu>
X-Newsreader: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 15:51:24 +0200
Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> This patch adds the generic GPIO support to the x86
> architecture. We do the same as for MIPS, we let
> the machine override the gpio callbacks and provide
> defaults one in mach-generic.
> 
[...]
> +
> +int gpio_request(unsigned gpio, const char *label);
> +void gpio_free(unsigned gpio);
> +int gpio_direction_input(unsigned gpio);
> +int gpio_direction_output(unsigned gpio, int value);
> +int gpio_get_value(unsigned gpio);
> +void gpio_set_value(unsigned gpio, int value);
> +int gpio_to_irq(unsigned gpio);
> +int irq_to_gpio(unsigned irq);

While I certainly would like to see a generic GPIO API, this one isn't
really useful for geode GPIOs.  It would be nice to have one that did
work for us as well.  Unfortunately, I haven't had the chance to give
much thought to this problem yet.


