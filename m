Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYI3MWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYI3MWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYI3MWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:22:25 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:60911 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYI3MWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:22:24 -0400
Date: Tue, 30 Sep 2008 14:22:07 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: AT49BV6416 has swapped erase regions
Message-ID: <20080930142207.72d5edaa@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <c384c5ea0809300502h48915058r78a6586968c1ac1a@mail.gmail.com>
References: <1222775733-6690-1-git-send-email-haavard.skinnemoen@atmel.com>
	<c384c5ea0809300502h48915058r78a6586968c1ac1a@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Sep 2008 12:21:53.0144 (UTC) FILETIME=[1F233F80:01C922F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:
> Haavard,
> 
> On Tue, Sep 30, 2008 at 1:55 PM, Haavard Skinnemoen
> <haavard.skinnemoen@atmel.com> wrote:
> > The CFI information read from AT49BV6416 lists the erase regions in the
> > wrong order, causing problems when trying to erase or update the first
> > or last 64K block.
> >
> Are there other Atmel designs with this bug or only the chip with this CFI ID?

That's a good question. I guess there may be others in the same family
with the same bug. I don't really know.

The replacement, AT49BV642D, does not have this bug.

> I ask, because the check in u-boot is too generic; I found u-boot
> wrongly assumes wrong order for another Atmel part, not checking on a
> specific CFI ID.

That's interesting...especially since u-boot only reads the low byte
of the JEDEC ID, so adding a fixup for one particular ID may match tons
of chips with 16-bit IDs.

I'll have to check the latest u-boot and see if it breaks any of my
boards.

Haavard
