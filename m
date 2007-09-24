Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXIXJvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXIXJvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 05:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXIXJvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 05:51:02 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:48955 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbXIXJvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 05:51:01 -0400
Subject: Re: What's in mmc.git for 2.6.24
From: Marcel Holtmann <marcel@holtmann.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070924102848.503a8d22@poseidon.drzeus.cx>
References: <20070924102848.503a8d22@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 11:47:59 +0200
Message-Id: <1190627279.5133.123.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

> There are currently three working drivers for this new stack:
> 
>  - sdio_uart: A driver for the standardised GPS and UART interfaces.
> Currently we only know how the GPS system works, so UART is only a
> future possibility.
> 
>  - libertas_sdio: Support for Marvell's 8686 Libertas wifi chip. Will
> be merged late in the merge window as there are some interdependencies
> between my tree and the libertas tree.

where can I get this driver? I have a bunch of SDIO WiFi cards that
might contain Libertas chip.

>  - hci_sdio: A driver for the standardised bluetooth interface. Marcel
> is in charge of this and I assume he intends to merge it as it is in a
> working condition.

The driver name will be btsdio and I will merge the initial version
within the 2.4.24 merge window. However this driver will go in via the
Bluetooth subsystem. My only request is that we can do the MMC merge
really early in the merge window.

Regards

Marcel


