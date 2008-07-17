Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbYGQPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYGQPFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYGQPFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:05:38 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:60359
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751663AbYGQPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:05:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 11:05:36 EDT
Date: Thu, 17 Jul 2008 10:58:54 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: <avorontsov@ru.mvista.com>
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
       <linuxppc-dev@ozlabs.org>, "Richard Purdie" <rpurdie@rpsys.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717105854.45427267@lappy.seanm.ca>
In-Reply-To: <20080717110730.GA24775@polina.dev.rtsoft.ru>
References: <20080714164114.GA18784@polina.dev.rtsoft.ru>
	<dc452eaab83710e7d6f86dcc5d77bdda@kernel.crashing.org>
	<20080717110730.GA24775@polina.dev.rtsoft.ru>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 15:07:30 +0400
"Anton Vorontsov" <avorontsov@ru.mvista.com> wrote:

> This is tricky question. Personally I place them inside the gpio
> controller node that is responsible for the LED. But I think placing
> the led nodes at top level would be also fine (maybe with "leds { }"
> node as a parent for all board's LEDs. What would you suggest for a
> "best practice"?

I also put the leds under the gpio controller for the Warp. It is then
very clear which gpio controller the leds belong to.

Putting them at the top level does not associate the leds with the
correct gpio controller.

Warning: I am *not* using the of gpio led driver, but I hope to move to
it once the dust settles and drop the current Warp specific driver ;)

Cheers,
   Sean
