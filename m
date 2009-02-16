Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZBPVzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZBPVzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZBPVz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:55:26 -0500
Received: from bu3sch.de ([62.75.166.246]:36474 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbZBPVzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:55:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] spi-gpio: Implement spidelay() for busses that need it.
Date: Mon, 16 Feb 2009 22:53:46 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200902151923.00120.mb@bu3sch.de> <200902161242.27773.david-b@pacbell.net>
In-Reply-To: <200902161242.27773.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902162253.46704.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 21:42:27 David Brownell wrote:
> [
>   NOTE:  removed openwrt from the cc list, it rejects posts
>   from non-subscribers.  Please don't cc such lists.
> ]

I'm sorry, I didn't know that it bounces nonsubscribers.

> On Sunday 15 February 2009, Michael Buesch wrote:
> > + * NOTE:  to clock "as fast as we can", set spi_device.max_speed_hz
> > + * and spi_transfer.speed_hz to 0.
> 
> Won't work; if spi->max_speed_hz is zero, spi_async() and
> friends will refuse to queue any messages.

Well, why would they do this? Any special reason?

> I'm not averse to a solution that lets some boards use a
> slowed-down bitbang loop.  But it would be a lot easier
> if you kept the default the way it is, and just added
> that slowdown as an option for the existing customization
> case (currently oriented towards speedup, not slowdown).

Tell me how to. This patch works for me and I'm only going to change it
if you tell me how to. I'm not so involved in the SPI subsystem that I can
see another obvious way to do this. So I need some advise, please.

-- 
Greetings, Michael.
