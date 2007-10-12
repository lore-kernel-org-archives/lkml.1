Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbXJLFbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbXJLFbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbXJLFbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:31:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932345AbXJLFbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:31:00 -0400
Date: Thu, 11 Oct 2007 22:30:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [GIT PULL] MMC updates
In-Reply-To: <20071010212149.0073ee08@poseidon.drzeus.cx>
Message-ID: <alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Oct 2007, Pierre Ossman wrote:
>
> Linus, please pull from
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus
> 
> Lot's of changes in here.

There seems to be some breakage here:

	drivers/mmc/core/host.c: In function ‘mmc_remove_host’:
	drivers/mmc/core/host.c:146: error: implicit declaration of function ‘led_trigger_unregister’
	drivers/mmc/core/host.c:146: error: ‘struct mmc_host’ has no member named ‘led’

this was after doing a few "make randconfig" runs, a habit I'm trying to 
encourage (and do myself occasionally too).

		Linus
