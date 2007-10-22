Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbXJVSDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbXJVSDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXJVSDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:03:38 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:54666 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXJVSDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:03:38 -0400
Date: Mon, 22 Oct 2007 20:03:35 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmc_spi stopped working
Message-ID: <20071022200335.7c1eca12@poseidon.drzeus.cx>
In-Reply-To: <20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071017211923.31fde15e@poseidon.drzeus.cx>
	<20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 12:37:13 -0700
David Brownell <david-b@pacbell.net> wrote:

> When enumerating MMC cards using SPI, don't support the "just probe"
> mechanism since it doesn't always work.  Instead, always wait for the
> reset to complete before issuing the next request.
> 
> This is a regression ... this SanDisk MMC card used to enumerate with
> no trouble, despite this particular spec violation.
> 

I've been testing a bit more here, and I can't get this particular bug. I have others though:

Out of my five MMC cards, only two work properly. One doesn't respond to SPI commands at all, and two hang on a second CMD0 and return ILLEGAL_COMMAND on a second run of CMD1. All of this is of course wildly out of spec. SPI seems to be a bonus, not a given. :/

As for your card, could you send me a dump as I'm unable to produce the issue here?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
