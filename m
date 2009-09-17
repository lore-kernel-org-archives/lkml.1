Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZIQVhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZIQVhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZIQVhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:37:23 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39985 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZIQVhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:37:22 -0400
Date: Thu, 17 Sep 2009 22:37:23 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Steve Chen <schen@mvista.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, linux-arm-kernel@lists.infradead.org,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH v2] arm: remove unused code in delay.S
Message-ID: <20090917213723.GC10599@shareable.org>
References: <1253017761.3273.117.camel@linux-1lbu> <200909151541.08852.marek.vasut@gmail.com> <1253032210.3273.128.camel@linux-1lbu> <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com> <1253043875.3273.131.camel@linux-1lbu> <m3k4zzdimy.fsf@intrepid.localdomain> <20090916134721.GA11218@n2100.arm.linux.org.uk> <20090917193257.GA10599@shareable.org> <20090917194119.GA12510@n2100.arm.linux.org.uk> <1253222978.3273.236.camel@linux-1lbu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253222978.3273.236.camel@linux-1lbu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Chen wrote:
> +	help
> +	  Enable this if observing longer than expected delays.  This code
> +	  improves delay accuracy for some CPUs.  However, it can also cause
> +	  delay duration to be too short for others which leads to stability
> +	  issues.
> +
> +	  In other words, do not enable unless you can guarantee that the
> +	  processor (or ALL of the processors if building a generic kernel)
> +	  delays for at least the time requested after enabling.
> +
>  endmenu

It would be very helpful to mention which CPUs are affected.
Ok, we don't know exactly...

But Russell has stated that ARM610 and ARM710 benefit from enabling
the code, and that it specifically must not be enabled for StrongARM.

Here's an additional paragraph to add on the end:

	ARM610 and ARM710 are known to benefit from enabling this option.
	It should not be enabled for StrongARMs, because it is known
	to produce too short delays on those.

Maybe you can adjust the config selectors and default to match?

-- Jamie
