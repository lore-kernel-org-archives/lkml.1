Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbXKXOhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbXKXOhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 09:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXKXOgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 09:36:54 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:46038 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXKXOgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 09:36:53 -0500
Date: Sat, 24 Nov 2007 15:36:50 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: nico@cam.org
Cc: Andre Haupt <andre@bitwigglers.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: Re: [PATCH] sdio_uart: fix sign of paramter status in
 sdio_uart_receive_chars()
Message-ID: <20071124153650.27a572a6@poseidon.drzeus.cx>
In-Reply-To: <11956448251191-git-send-email-andre@bitwigglers.org>
References: <11956448251191-git-send-email-andre@bitwigglers.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 12:33:45 +0100
Andre Haupt <andre@bitwigglers.org> wrote:

> I think, the status paramter should be unsigned. Is this correct?
> This also fixes a sparse warning about different signedness.
> Only compile tested, because i do not have the hardware.
> 
> From: Andre Haupt <andre@bitwigglers.org>
> Signed-off-by: Andre Haupt <andre@bitwigglers.org>

Nicolas, does this seem correct to you? I'm not familiar with the serial stuff.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
