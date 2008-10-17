Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYJQIxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYJQIxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYJQIxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:53:30 -0400
Received: from bu3sch.de ([62.75.166.246]:54581 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYJQIx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:53:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Magnus Damm" <magnus.damm@gmail.com>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Date: Fri, 17 Oct 2008 10:52:54 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>,
       "Piot Skamruk" <piotr.skamruk@gmail.com>,
       openwrt-devel@lists.openwrt.org
References: <200807202146.12759.mb@bu3sch.de> <aec7e5c30810162014w33fe08f2ta2b05cb187770e3a@mail.gmail.com>
In-Reply-To: <aec7e5c30810162014w33fe08f2ta2b05cb187770e3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810171052.54823.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2008 05:14:26 Magnus Damm wrote:
> On Mon, Jul 21, 2008 at 4:46 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > This adds a driver that lets you drive an SPI bus over
> > generic GPIO pins.
> >
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Very useful. Fits my shiny new GPIO implementation for SuperH like a glove.
> 
> Michael, as you know, I have some SuperH board code that makes use of
> this driver. Are there any outstanding issues with this driver that I
> can help resolving?

bool cs_activelow should probably be removed from struct spi_gpio_platform_data.

I think cs always is activelow, so we can simply hardcode this in spi_gpio_chipselect()

If you want to do this, please feel free to do so.
I currently don't have the time for this.
The rest of the driver is fine with me.

-- 
Greetings Michael.
