Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbXGIKvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbXGIKvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXGIKv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:51:29 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46983 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbXGIKv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:51:28 -0400
Date: Mon, 9 Jul 2007 12:51:25 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: wux@landicorp.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Hamish Guthrie <hamish@prodigi.ch>,
       Andrew Victor <andrew@sanpeople.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] mmc: at91_mci: fix hanging and rework to match
 flowcharts
Message-ID: <20070709125125.4d4bc2bc@poseidon.drzeus.cx>
In-Reply-To: <4688FE50.7050806@drzeus.cx>
References: <4688EC94.1090901@rfo.atmel.com>
	<4688FE50.7050806@drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jul 2007 15:32:00 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Nicolas Ferre wrote:
> > Fixes hanging using multi block operations (seen during CMD25).
> > Follows closely the datasheet flowcharts.
> > 
> > This piece of code handles better big file writing. I had to take
> > care of the notbusy signal during write (at91_mci_handle_cmdrdy
> > function) and to rearrange the AT91_MCI_ENDRX and AT91_MCI_RXBUFF
> > flag usage.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> > ---
> 
> Most of the patch looks ok. Do you want to wait for some more tests
> or should I chuck this into the imminent merge window?
> 

*ping*

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
