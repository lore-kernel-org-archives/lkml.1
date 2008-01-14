Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYANP71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYANP71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYANP6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:58:04 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61586 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753930AbYANP6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:58:03 -0500
Date: Mon, 14 Jan 2008 16:57:54 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Marc Pignat <marc.pignat@hevs.ch>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH, take 2] watchdog on generic gpio
Message-ID: <20080114165754.46e187f3@siona>
In-Reply-To: <200801141503.15359.florian.fainelli@telecomint.eu>
References: <200801141103.23744.marc.pignat@hevs.ch>
	<200801141206.39858.florian.fainelli@telecomint.eu>
	<200801141401.33783.marc.pignat@hevs.ch>
	<200801141503.15359.florian.fainelli@telecomint.eu>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 15:03:14 +0100
Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> Le lundi 14 janvier 2008, Marc Pignat a écrit :
> > Hi Florian!
> > I understand your wish, but...
> > You told me that your plaform doesn't implement the generic gpio
> > interface (yet?), so this driver can't work for you.  
> 
> You understood me wrong, I told you that not all platforms, actually
> only AVR32 and ARM seem to make use of David Brownell's gpiolib, but
> the MIPS board I am working with supports the "old" generic GPIO API
> which required you to define your own wrappers for gpio_set/get_value
> and such. For both implementations the config symbol is GENERIC_GPIO,
> which can somehow be confusing.

GENERIC_GPIO means that some implementation of the generic GPIO API is
present. Gpiolib is a specific implementation of that API which
architectures may choose to utilize -- it doesn't change anything that
drivers should care about.

Haavard
