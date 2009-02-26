Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZBZWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZBZWQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZBZWQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:16:40 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:48559 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZBZWQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:16:40 -0500
Subject: Re: [patch 2.6.29-rc3-git 2/2] USB: disable twl4030 USB regulators
 when cable unplugged
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, OMAP <linux-omap@vger.kernel.org>,
       Kalle Jokiniemi <kalle.jokiniemi@digia.com>
In-Reply-To: <200902081053.00255.david-b@pacbell.net>
References: <200902081053.00255.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 22:16:36 +0000
Message-Id: <1235686596.31223.106.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-08 at 10:52 -0800, David Brownell wrote:
> From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
> 
> This patch disables LDO regulators VUSB1V5, VUSB1V8, and VUSB3V1
> when the USB cable is unplugged, to eliminate that source of power
> waste.  (Enabled LDOs consume power at all times.)
> 
> Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> Depends on the twl4030 regulator driver, so I'm suggesting this
> be merged (with that driver) through the regulator patch queue
> to simplify things.
> 
>  drivers/usb/otg/twl4030-usb.c |   30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)

Applied.

Thanks

Liam

