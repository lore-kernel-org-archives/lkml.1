Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZG3Pzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZG3Pzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZG3Pzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:55:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:36773 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZG3Pze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <20090730124543.GF3058@console-pimps.org>
References: <1248954848.5396.6.camel@localhost> <20090730124543.GF3058@console-pimps.org>
From: Ohad Ben-Cohen <ohad@bencohen.org>
Date: Thu, 30 Jul 2009 18:55:14 +0300
Message-ID: <bd5b16740907300855y2ee0f76fv5886606fcee241b7@mail.gmail.com>
Subject: Re: [PATCH] sdio: add CD disable support
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, ian@mnementh.co.uk,
       pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es,
       Adrian Hunter <adrian.hunter@nokia.com>, Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 3:45 PM, Matt Fleming<matt@console-pimps.org> wrote:
> Do you have a follow-up patch to make use of this new functionality?

Well, sort of:

The patch sets disable_cd for TI wl1271 embedded wlan sdio device on a
ZOOM2 platform.

Since the patch is very board/device specific, we first route it via
internal maintainers, so it is not posted yet.

It's nothing fancy:

diff --git a/arch/arm/mach-omap2/mmc-twl4030.c
b/arch/arm/mach-omap2/mmc-twl4030.c
index 5b64bf1..caa8b16 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -81,6 +81,7 @@ static struct embedded_sdio_data omap_wifi_emb_data = {
 		.wide_bus       = 1,
 		.high_power     = 0,
 		.high_speed     = 0,
+		.disable_cd	= 1,
 	},
 	.funcs  = wifi_func_array,
 	.num_funcs = 2,
