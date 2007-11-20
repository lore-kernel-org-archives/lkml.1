Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbXKTQkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbXKTQkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXKTQjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:39:55 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:39065 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbXKTQjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:39:55 -0500
Date: Tue, 20 Nov 2007 17:39:51 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: djenkins@mvista.co.uk
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: MMC sub-system: SDIO block-mode with increment address
 issue]
Message-ID: <20071120173951.334f7a2f@poseidon.drzeus.cx>
In-Reply-To: <1195570357.13874.17.camel@libdev3.libertesoft.co.uk>
References: <1195554533.18869.111.camel@libdev3.libertesoft.co.uk>
	<20071120115104.163810ea@poseidon.drzeus.cx>
	<1195570357.13874.17.camel@libdev3.libertesoft.co.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 14:52:37 +0000
Dean Jenkins <djenkins@mvista.co.uk> wrote:

> Hi Pierre,
> 
> My card driver needed to set the R/W E4MI bit in the Card Capability
> register (0x08) in CCCR (function 0). Perhaps it is unnecessary ?
> 

That bit is pointless given the current design of the MMC layer, so it shouldn't be necessary.

> BTW. It is easy to for the card driver to access function 0 registers by
> doing the following...
> 

Of course. Any driver can do whatever it pleases since it is in kernel space. But you won't make any friends if you keep trying to bypass every system in the kernel. ;)

(Not to mention you'll have a lot more work on your hands.)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
