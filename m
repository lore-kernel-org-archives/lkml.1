Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZAAPKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZAAPKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 10:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZAAPK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 10:10:26 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4299 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZAAPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 10:10:25 -0500
Date: Thu, 1 Jan 2009 10:09:57 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20090101150957.GA14921@hash.localnet>
References: <1230641016.5770.5.camel@maxim-laptop> <20081231091845.GA2516@rhlx01.hs-esslingen.de> <20081231140308.GA26600@hash.localnet> <1230742291.26499.22.camel@maxim-laptop> <20090101134100.GA4819@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090101134100.GA4819@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 02:41:00PM +0100, Andreas Mohr wrote:
> I believe the 80211 layer itself should provide some generic LED
> handling which then provide for reliable and _identical_ displaying of
> mess with custom rssi-indicating LED type implementations,
> this should be centralized to have one template for an RSSI LED.

Agreed, I suggested this in another thread.  I don't have any LEDs so it 
would be better if someone else did the work.  (I should really build a 
little usb->serial device with a couple of lights on it and hook it up
to the triggers so I can pretend...)

> More notes:
>  checks of AR5K_NUM_GPIO most certainly are buggy: off-by-1
>   (range sems to be 0-5, _not_ 1-6)

Nice catch, that has been there since day 0.

>  prepend "Acer" to "Aspire One" in this patch

Will do and I'll invert the logic level in the resend.  Thanks for the
feedback.

-- 
Bob Copeland %% www.bobcopeland.com

