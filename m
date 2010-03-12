Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0CLKTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:19:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58965 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab0CLKTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:19:13 -0500
Date: Fri, 12 Mar 2010 10:18:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, alsa-devel@alsa-project.org,
       dinuxbg@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] Quick fix for the audio clocks on SAM9-L9261
Message-ID: <20100312101859.GC29306@n2100.arm.linux.org.uk>
References: <20100312105817.4392b594@rechenknecht2k7> <20100312110032.2e57fdce@rechenknecht2k7> <20100312110241.3d97237b@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312110241.3d97237b@rechenknecht2k7>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 11:02:41AM +0100, Benjamin Valentin wrote:
> Signed-off-by: Dimitar Dimitrov <dimitar@olimex.com>

This should be...

> >From 10a85229b2357c89d5170efde5ac0e1cba4c9f9e Mon Sep 17 00:00:00 2001
> From: Dimitar Dimitrov <dimitar@olimex.com>
> Date: Wed, 27 May 2009 08:11:37 +0300
> Subject: [PATCH] Quick fix for the audio clocks on SAM9-L9261
> 
> This patch together with support from SAM9-L9261 hardware fix an issue with
> audio clocks. AT73C213 needs MCLK and BCLK with equal phase. The MCLK from
> AT91SAM9XXX clock output and BCLK from the SSC TK clock output are not
> phase-synchronized. Thus the SAM9-L9261 board provides external hardware
> divison by 8 from MCLK to BCLK, ensuring zero phase difference.
> 
> See: http://www.at91.com/phpbb/viewtopic.php?t=2633

... here.  It's supposed to be part of the commit message.
