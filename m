Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYBEOPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYBEOPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYBEOP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:15:26 -0500
Received: from smtp2b.orange.fr ([80.12.242.144]:61997 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYBEOPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:15:25 -0500
X-ME-UUID: 20080205132651974.EDCF970000A5@mwinf2b22.orange.fr
Subject: Re: [Patch 1/1] Nikon D80 usb-storage quirk needs modified, new FW
From: Xavier Bestel <xavier.bestel@free.fr>
To: Konstantin Kletschke <lists@ku-gbr.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080205124343.GB6638@anita>
References: <20080205124343.GB6638@anita>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 14:26:48 +0100
Message-Id: <1202218008.23816.9.camel@skunk.anacadf.mentorg.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 13:43 +0100, Konstantin Kletschke wrote:
> Nikon did update their FW for the Nikon D80 and usb-storage got
> unusable:
[...]
> I relized the unusal_devs.h needs to be adapted to 
> reflect new FW Version, then it works fine again:
> 
> --- linux-2.6.23/drivers/usb/storage/unusual_devs.h_orig        2008-02-05 13:33:55.010623616 +0100
> +++ linux-2.6.23/drivers/usb/storage/unusual_devs.h     2008-02-05 13:32:22.926623601 +0100
> @@ -342,7 +342,7 @@
>                 US_FL_FIX_CAPACITY),
> 
>  /* Reported by Emil Larsson <emil@swip.net> */
> -UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0101,
> +UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
>                 "NIKON",
>                 "NIKON DSC D80",
>                 US_SC_DEVICE, US_PR_DEVICE, NULL,
> 
> 
> What I wonder is, why are there other examples only reflecting the
> newest Firmware, are older ones also catched?

Maybe you should leave them both here.

	Xav


