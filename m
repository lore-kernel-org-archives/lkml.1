Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZF1XAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZF1XAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 19:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZF1XAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 19:00:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbZF1W77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:59:59 -0400
Date: Mon, 29 Jun 2009 01:00:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "rubenatch@gmail.com" <rubenatch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] Adding rumble support to Thrustmaster Dual Trigger
 3-in-1 devices
In-Reply-To: <alpine.DEB.2.00.0906261639570.17888@localhost>
Message-ID: <alpine.LNX.2.00.0906290058370.18021@wotan.suse.de>
References: <alpine.DEB.2.00.0906261639570.17888@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-39250729-1246230002=:18021"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-39250729-1246230002=:18021
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 26 Jun 2009, rubenatch@gmail.com wrote:

> 
> From: Rubén Aós Garralda <rubenatch@gmail.com>
> 
> This patch enables rumble in Thrustmaster Dual 3-in-1 trigger gamepads (in
> both PC and PS3 modes). It uses the same code as Thrustmaster FireStorm Dual
> Power 2/3, so it only modifies hid-core.c (to put the devices in the
> "forbidden list" and hid-tmff.c to add the new USB IDs.

Could you please also send your Signed-off-by: line, so that I can 
properly merge the patch?

> diff -uprN linux-source-2.6.30/drivers/hid/hid-core.c
> linux-source-test/drivers/hid/hid-core.c
> --- linux-source-2.6.30/drivers/hid/hid-core.c	2009-06-10 05:05:27.000000000
> +0200
> +++ linux-source-test/drivers/hid/hid-core.c	2009-06-26 15:33:48.000000000
> +0200
> @@ -1309,6 +1309,8 @@ static const struct hid_device_id hid_bl
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS,
>  	USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
> +       	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324) },

This is whitespace damaged.

Otherwise the patch is OK.

Thanks!

-- 
Jiri Kosina
SUSE Labs
--168427776-39250729-1246230002=:18021--
