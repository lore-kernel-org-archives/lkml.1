Return-Path: <linux-kernel-owner+w=401wt.eu-S1759183AbYGPWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbYGPWQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYGPWQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:16:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbYGPWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:16:34 -0400
Date: Wed, 16 Jul 2008 15:16:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates for 2.6.26
In-Reply-To: <20080715160436.0f6ac19e@mjolnir.drzeus.cx>
Message-ID: <alpine.LFD.1.10.0807161512030.2835@woody.linux-foundation.org>
References: <20080715160436.0f6ac19e@mjolnir.drzeus.cx>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Pierre Ossman wrote:
>
>  45 files changed, 6054 insertions(+), 1320 deletions(-)

If you had done the "--summary", you'd also have seen these bogus:

	 mode change 100644 => 100755 drivers/mmc/core/sdio_io.c
	 mode change 100644 => 100755 include/linux/mmc/sdio_func.h

entries.

I have no idea why you think those things should be executable, but it 
happened in commit 6d37333163025b46afbcad434ec9a5f2e88e7254 ("mmc: fix 
sdio_io sparse errors").

Anyway, there's a reason why I ask people to use

	--diffstat --summary -M

when generating the report. This is just part of it.

I fixed it up in the merge, so it's ok in my tree, but I thought I'd point 
it out.

		Linus
