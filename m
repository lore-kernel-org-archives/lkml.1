Return-Path: <linux-kernel-owner+w=401wt.eu-S1761834AbYFZPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834AbYFZPKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYFZPKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:10:30 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:60947 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYFZPK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:10:29 -0400
Date: Thu, 26 Jun 2008 16:46:01 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for
 AVR32 users
Message-ID: <20080626164601.712bf048@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080626141552.GB30954@cs181140183.pp.htv.fi>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	<20080626141552.GB30954@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 14:45:45.0716 (UTC) FILETIME=[50E53340:01C8D79B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:
> That discussion is mixing two different things I suggested besides other 
> things before the Kconfig file was added [1]:
> - have DMA_ENGINE select'ed when a device gets enabled by the user,
>   and not be an independent option
> - switch to menuconfig and don't offer an empty kconfig menu
> 
> There seems to be no disagreement about the former (which could 
> otherwise easily lead to users mistakenly enabling NET_DMA).
> 
> The latter is more a cosmetical kconfig UI thing, and I already said
> back then that it "could be dropped if it would become a problem" [2].

Ok, thanks for explaining. The menu does appear empty if I remove the
architecture dependency without adding the driver...if that's a problem
maybe we should do the HAVE_DMA_DEVICE thing...

> So if you want to remove the architecture dependency from the DMADEVICES 
> menu that's OK with me.

Ok, I'm gonna wait for Dan and others to respond. If it's fine with
them, I'll post a patch removing the arch dependency.

Haavard
