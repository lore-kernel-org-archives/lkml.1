Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXJLFqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXJLFqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXJLFqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:46:01 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:33489 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbXJLFqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:46:00 -0400
Date: Fri, 12 Oct 2007 07:45:56 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20071012074556.574584db@poseidon.drzeus.cx>
In-Reply-To: <alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
	<alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 22:30:41 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> There seems to be some breakage here:
> 
> 	drivers/mmc/core/host.c: In function ‘mmc_remove_host’:
> 	drivers/mmc/core/host.c:146: error: implicit declaration of
> function ‘led_trigger_unregister’ drivers/mmc/core/host.c:146: error:
> ‘struct mmc_host’ has no member named ‘led’
> 
> this was after doing a few "make randconfig" runs, a habit I'm trying
> to encourage (and do myself occasionally too).
> 

How embarrassing. I'll have a look at it and reping you when I've
solved it.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
