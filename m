Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbXJQTwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbXJQTwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbXJQTwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:52:21 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:40588 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbXJQTwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:52:20 -0400
Date: Wed, 17 Oct 2007 21:52:17 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmc_spi stopped working
Message-ID: <20071017215217.177cdb14@poseidon.drzeus.cx>
In-Reply-To: <20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071017211923.31fde15e@poseidon.drzeus.cx>
	<20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 12:37:13 -0700
David Brownell <david-b@pacbell.net> wrote:

> 
> That issue is 49dce689ad4ef0fd1f970ef762168e4bd46f69a3, the
> classdev-elimination patch from Tony Jones.  It broke the
> "does this bus have more than one device" test by relocating
> the relevant sysfs nodes.
> 
> Quick workaround for that one is to disable the fault return
> after that test.
> 

Annoying. Feel free to ping me when you've pushed fixes to Linus.

> When enumerating MMC cards using SPI, don't support the "just probe"
> mechanism since it doesn't always work.  Instead, always wait for the
> reset to complete before issuing the next request.
> 
> This is a regression ... this SanDisk MMC card used to enumerate with
> no trouble, despite this particular spec violation.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 

I think I'll have to NAK this as I believe it breaks MMC 4.2. I'll check
and get back to you.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
