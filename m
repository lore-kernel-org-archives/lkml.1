Return-Path: <linux-kernel-owner+w=401wt.eu-S1763275AbYARRFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763275AbYARRFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbYARRFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:05:12 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:60964 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbYARRFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:05:10 -0500
Message-ID: <4790DC33.2070104@freescale.com>
Date: Fri, 18 Jan 2008 11:04:51 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to
 CPM serial driver.
References: <478F4AE3.5090803@scram.de>
In-Reply-To: <478F4AE3.5090803@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> +void watchdog_poke(void)
> +{
> +    if (wdt) {
> +        out_be16(&wdt->swsrr, 0x556c);
> +        out_be16(&wdt->swsrr, 0xaa39);
> +    }
> +}

This should be a function pointer, to allow for other watchdog types.

-Scott
