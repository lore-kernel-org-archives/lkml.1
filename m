Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbYK3Kdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbYK3Kdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 05:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYK3Kdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 05:33:44 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50957 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYK3Kdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 05:33:43 -0500
Subject: Re: Dell Wireless 365 requires reset quirk
From: Marcel Holtmann <marcel@holtmann.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mario Limonciello <mario_limonciello@dell.com>
In-Reply-To: <491CCD86.7050904@canonical.com>
References: <20081104162448.A338EF8A65@sepang.rtg.net>
	 <20081111145706.9bfb4627.akpm@linux-foundation.org>
	 <491CCD86.7050904@canonical.com>
Content-Type: text/plain
Date: Sun, 30 Nov 2008 11:33:39 +0100
Message-Id: <1228041219.9176.10.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

> >> >From 931ccb629d739aa563347a4e866bc26107e6b545 Mon Sep 17 00:00:00 2001
> >> From: Tim Gardner <tim.gardner@canonical.com>
> >> Date: Tue, 4 Nov 2008 09:18:06 -0700
> >> Subject: [PATCH] Dell Wireless 365 needs BTUSB_RESET quirk.
> >>  OriginalAuthor: Mario Limonciello <mario_limonciello@dell.com>
> >>
> >> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> >> Cc: stable@kernel.org
> >> ---
> >>  drivers/bluetooth/btusb.c |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> >> index af472e0..051b758 100644
> >> --- a/drivers/bluetooth/btusb.c
> >> +++ b/drivers/bluetooth/btusb.c
> >> @@ -125,6 +125,9 @@ static struct usb_device_id blacklist_table[] = {
> >>  	/* Dell laptop with Broadcom chip */
> >>  	{ USB_DEVICE(0x413c, 0x8126), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
> >>  
> >> +	/* Dell Wireless 365 */
> >> +	{ USB_DEVICE(0x413c, 0x8160), .driver_info = BTUSB_RESET },
> >> +
> >>  	/* Dell Wireless 370 */
> >>  	{ USB_DEVICE(0x413c, 0x8156), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
> >>  
> > 
> > I shall assume that this patch was authored by Mario.  This should have
> > been communicated by adding his From: line right at the top of the
> > changelog.  Mario's signed-off-by: is absent, but that is tolerable
> > because we have yours.
> > 
> > The (absent) changelog fails to explain what effect this patch has. 
> > _why_ does this driver need this quirk?
> > 
> > As it stands, there is insufficient information here for making
> > 2.6.28-vs-2.6.29 decisions, let alone 2.6.27.x, 2.6.26.x, etc.
> > 
> 
> Is this better (aside from being an attachment) ?

the patch will no longer be needed. I am making HCI Reset the default
and only letting the old drivers quirk a NO_RESET.

Regards

Marcel


