Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXK1W0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXK1W0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXK1W0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:26:09 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:54698 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbXK1W0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:26:07 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <474DEAF7.6000301@am.sony.com>
Date: Wed, 28 Nov 2007 14:25:59 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/7] ps3: Use the HVs storage device notification mechanism
 properly
References: <20071128143142.580732000@pademelon.sonytel.be> <20071128143438.302492000@pademelon.sonytel.be>
In-Reply-To: <20071128143438.302492000@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2007 22:26:01.0583 (UTC) FILETIME=[A812D7F0:01C8320D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> ps3: Use the HV's storage device notification mechanism properly
> 
> The hypervisor has a storage device notification mechanism to wait until a
> storage device is ready. Unfortunately the storage device probing code used
> this mechanism in an incorrect way, needing a polling loop and handling of
> devices that are not yet ready.
> 
> This change corrects this by:
>   - First waiting for the reception of an asynchronous notification that a new
>     storage device became ready,
>   - Then looking up the storage device in the device repository.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  arch/powerpc/platforms/ps3/device-init.c |  395 +++++++++++++++----------------
>  arch/powerpc/platforms/ps3/platform.h    |    2 
>  arch/powerpc/platforms/ps3/repository.c  |   29 --
>  3 files changed, 194 insertions(+), 232 deletions(-)

Let's hope this is the end of the storage device notification saga!

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

