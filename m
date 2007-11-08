Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbXKHVIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbXKHVIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbXKHVIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:08:18 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:36712 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013AbXKHVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:08:17 -0500
Date: Thu, 8 Nov 2007 22:05:46 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] r8169 fix regression on ASUS motherboards (updated
	again)
Message-ID: <20071108210546.GA8780@electric-eye.fr.zoreil.com>
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca> <20071107220455.GA15367@electric-eye.fr.zoreil.com> <47323A69.5050206@rtr.ca> <47323B6B.9000909@rtr.ca> <47324843.4050602@rtr.ca> <20071108002112.GD15367@electric-eye.fr.zoreil.com> <47331A2C.6050005@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47331A2C.6050005@rtr.ca>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <lkml@rtr.ca> :
[snip snip] 
> Stop the presses:  Another person has now reported back to me.
> This guy has the VER_17 chip inside a notebook, and the same problem.
> 
> So the unified fix for all of these is to just get rid of 
> rtl8168b_hw_phy_config(),
> as that code is all that is really different from 2.6.23 (where all is 
> okay).
> 
> Updated patch below.

Thanks. I'll push an update for it and probably a fix for a different
annoyance before going to bed.

It will help future developments if you can convince the shadow man to
send a few informations: I have no known tester for the VER_17 chip.

As a side note, people should really really really consider posting on
netdev@vger.kernel.org when reporting test results.

-- 
Ueimor
