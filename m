Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567Ab0A2QlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0A2QlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406Ab0A2QlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:41:04 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:44375 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0A2QlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:41:01 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Fri, 29 Jan 2010 17:41:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Ming Lei <tom.leiming@gmail.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com> <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com> <1264782843.4242.91.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1264782843.4242.91.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001291741.11786.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 29. Januar 2010 17:34:03 schrieb Catalin Marinas:

> I was thinking about checking dev->bus->controller->dma_mask which the
> code (though not the storage one) seems to imply that if the dma_mask is
> 0, the HCD driver is only capable of PIO.

That a HCD is capable of DMA need not imply that DMA is used for every
transfer.
 
> That would be a more general solution rather than going through each HCD
> driver since my understanding is that flush_dcache_page() is only needed
> together with the mass storage support.

What about ub, nfs or nbd over a USB<->ethernet converter?
This, I am afraid is best solved at the HCD or glue layer.

	Regards
		Oliver
