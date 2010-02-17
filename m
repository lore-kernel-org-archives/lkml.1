Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab0BQJu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:50:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33128 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab0BQJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:50:24 -0500
Date: Wed, 17 Feb 2010 10:50:00 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Andy Green <andy@warmcat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100217095000.GA17643@pengutronix.de>
References: <20100208065519.GE1290@ucw.cz> <1265622676.4020.19.camel@pc1117.cambridge.arm.com> <4B6FE162.6000004@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6FE162.6000004@warmcat.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 10:49:13 up 127 days, 22:38, 44 users,  load average: 0.03, 0.40,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 11:03:14AM +0100, Andy Green wrote:
> On 02/08/10 10:51, Somebody in the thread at some point said:
>
>> We could of course flush the caches every time we get a page fault but
>> that's far from optimal, especially since DMA-capable drivers to do not
>> pollute the D-cache and don't need this extra flushing. Note that the
>> recent ARM processors have PIPT caches but separate for I and D and it's
>> the PIO drivers that pollute the D-cache.
>
> Just noting that AFAIK iMX31 USB and MMC drivers both are PIO at the  
> moment, for lack of any platform DMA support of its unusual DMA engine.

The EHCI module has its own DMA engine and has nothing to do with the
SDMA engine.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
