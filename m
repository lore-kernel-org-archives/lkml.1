Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbXJOWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbXJOWJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXJOWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:09:09 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:49125 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbXJOWJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:09:07 -0400
X-IronPort-AV: i="4.21,279,1188792000"; 
   d="scan'208"; a="41778185:sNHT37770096"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Blackfin serial driver: this driver enable SPORTs on Blackfin emulate UART
Date: Mon, 15 Oct 2007 18:10:02 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <bryan.wu@analog.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1192098220-25828-1-git-send-email-bryan.wu@analog.com> <1192098220-25828-4-git-send-email-bryan.wu@analog.com> <20071015133326.995a4f38.akpm@linux-foundation.org>
In-Reply-To: <20071015133326.995a4f38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710151810.02291.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 15 Oct 2007 22:09:05.0837 (UTC) FILETIME=[00774DD0:01C80F78]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15 Oct 2007 16:33, Andrew Morton pondered:
> 
> > Subject: [PATCH 3/3] Blackfin serial driver: this driver enable SPORTs
> on Blackfin emulate UART
> 
> That's a bit hard to parse.
> 

Blackfin's have a synchronous Serial Peripheral pORT (SPORT). 

Unlike SPI, UART, I2C, or CAN interfaces which are designed for specific 
industry standard compatible communication only, the SPORT support a variety 
(software programmable) serial data communication protocols:
 - A-law or µ-law companding according to G.711 specification
 - Multichannel or Time-Division-Multiplexed (TDM) modes
 - Stereo Audio I2S Mode
 - TDM Modes for Multi-Channel audio codecs
 - H.100 Telephony standard support
 - others, but if anyone really cares, they need to read the chip specs...

Bryan's patch takes the SPORT, and makes a standard UART out of it 
(exposing /dev/ttySS0) for those people who don't have enough hardware UARTs 
in their system.

Is it a SPORT driver that emulates a UART, or a UART driver on the SPORT? I 
think it is the latter...

Maybe:

[PATCH 3/3] Blackfin serial driver: enables a UART interface for the SPORT


Which still doesn't make any sense, until you know what a SPORT is :)

-Robin
