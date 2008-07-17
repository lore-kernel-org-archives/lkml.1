Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYGQF7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYGQF7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 01:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYGQF7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 01:59:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:45173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbYGQF7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:59:35 -0400
In-Reply-To: <20080714164114.GA18784@polina.dev.rtsoft.ru>
References: <20080714164114.GA18784@polina.dev.rtsoft.ru>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <dc452eaab83710e7d6f86dcc5d77bdda@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Richard Purdie <rpurdie@rpsys.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] leds: implement OpenFirmare GPIO LED driver
Date: Thu, 17 Jul 2008 07:59:03 +0200
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt 
> b/Documentation/powerpc/dts-bindings/gpio/led.txt
> new file mode 100644
> index 0000000..7e9ce81
> --- /dev/null
> +++ b/Documentation/powerpc/dts-bindings/gpio/led.txt
> @@ -0,0 +1,15 @@
> +LED connected to GPIO
> +
> +Required properties:
> +- compatible : should be "gpio-led".

This "compatible" name is a bit too generic.  No, I don't know a
better name :-(

> +- label : (optional) the label for this LED. If omitted, the label is
> +  taken from the node name (excluding the unit address).

What is a label?  It should be described here.  Also, its encoding
should be described ("a string" I guess).

> +- gpios : should specify LED GPIO.
> +
> +Example:
> +
> +led@0 {
> +	compatible = "gpio-led";
> +	label = "hdd";
> +	gpios = <&mcu_pio 0 0>;
> +};

You show a unit address but have no "reg" value.  This is
incorrect.

What would be the parent node of this, btw?


Segher

