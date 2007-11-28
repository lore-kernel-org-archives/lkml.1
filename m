Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXK1WaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXK1WaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXK1WaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:30:06 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:8285 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385AbXK1WaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:30:03 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <474DEB78.6010209@am.sony.com>
Date: Wed, 28 Nov 2007 14:28:08 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/7] ps3: Add repository polling loop to work around	hypervisor
 bug
References: <20071128143142.580732000@pademelon.sonytel.be> <20071128143438.407055000@pademelon.sonytel.be>
In-Reply-To: <20071128143438.407055000@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2007 22:28:10.0318 (UTC) FILETIME=[F4CE3EE0:01C8320D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> ps3: Add repository polling loop to work around hypervisor bug
> 
> On some firmware versions (e.g. 1.90), the storage device may not show up
> in the repository immediately after receiving the notification message.
> Add a small polling loop to make sure we don't miss it.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  arch/powerpc/platforms/ps3/device-init.c |   47 ++++++++++++++++++++++---------
>  1 files changed, 34 insertions(+), 13 deletions(-)

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>


