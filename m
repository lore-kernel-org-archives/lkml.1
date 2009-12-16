Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZLPRsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZLPRsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZLPRsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:48:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54828 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909AbZLPRsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:48:36 -0500
Date: Wed, 16 Dec 2009 17:47:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
       David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       "David S. Miller" <davem@davemloft.net>,
       Kurt Van Dijck <kurt.van.dijck@eia.be>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] can/at91: don't check platform_get_irq's return
 value against zero
Message-ID: <20091216174749.277761fe@lxorguk.ukuu.org.uk>
In-Reply-To: <20091216170802.GA26325@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de>
	<1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
	<1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
	<4B290A57.3010705@grandegger.com>
	<20091216170802.GA26325@pengutronix.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       if (!res || irq <= (int)NO_IRQ) {
> 
> but this looks too ugly.  (IMHO using NO_IRQ is already ugly.)

No IRQ was a private variable for the drivers/ide stack internally and
only present in any form on a few odd platforms where it got "borrowed"
and hasn't yet been eliminated

The absence of an IRQ is zero. A bus IRQ of zero is remapped by the OS.

Alan
