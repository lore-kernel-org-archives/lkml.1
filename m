Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXK1WRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXK1WRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbXK1WQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:16:56 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:11448 "EHLO
	mail14-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbXK1WQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:16:55 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <474DE8CF.80305@am.sony.com>
Date: Wed, 28 Nov 2007 14:16:47 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/7] ps3: Make bus_id and dev_id u64
References: <20071128143142.580732000@pademelon.sonytel.be> <20071128143438.096659000@pademelon.sonytel.be>
In-Reply-To: <20071128143438.096659000@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2007 22:16:49.0224 (UTC) FILETIME=[5ED78C80:01C8320C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> ps3: Make bus_id and dev_id u64.
> 
> These IDs are 64-bit in the repository, and the special storage notification
> device has a device ID of ULONG_MAX.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  arch/powerpc/platforms/ps3/device-init.c |    4 ++--
>  arch/powerpc/platforms/ps3/mm.c          |    8 ++++----
>  arch/powerpc/platforms/ps3/platform.h    |   12 ++++++------
>  arch/powerpc/platforms/ps3/repository.c  |   21 ++++++++-------------
>  arch/powerpc/platforms/ps3/system-bus.c  |   14 +++++++-------
>  drivers/net/ps3_gelic_net.c              |    4 ++--
>  include/asm-powerpc/ps3.h                |    4 ++--
>  7 files changed, 31 insertions(+), 36 deletions(-)
> 

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

I saw where 0 passed as a pointer was changed to NULL in your
patch [7] ps3: denoise arch/powerpc/platforms/ps3/repository.c,
so this looks good.

-Geoff


