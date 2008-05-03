Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbYECQtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbYECQtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 12:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYECQsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 12:48:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42389 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYECQsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 12:48:52 -0400
Date: Sat, 3 May 2008 19:47:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [patch/bugreport] rt2x00: build fix
Message-ID: <20080503164754.GL5838@cs181133002.pp.htv.fi>
References: <20080503124711.GA18244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080503124711.GA18244@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 02:47:11PM +0200, Ingo Molnar wrote:
> 
> x86.git testing found the following build failure on latest -git:
> 
>    Building modules, stage 2.
>    MODPOST 332 modules
>  ERROR: "led_classdev_unregister" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  ERROR: "led_classdev_resume" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  ERROR: "led_classdev_register" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  ERROR: "led_classdev_suspend" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  make[1]: *** [__modpost] Error 1
>  make: *** [modules] Error 2
> 
> config can be found at:
> 
>   http://redhat.com/~mingo/misc/config-Sat_May__3_13_24_19_CEST_2008.bad
> 
> the patch here is just a quick workaround for now for my test-setup, it 
> makes the leds features in this driver depend on NEW_LEDS. Have not 
> checked how far away this is from the real fix. Hm, and i think think i 
> sent another patch for a similar build failure a week ago already - did 
> i miss some patch to try?

You missed Roman's patch two days ago, that was in response to a similar 
report you sent, and that will also fix this issue.

> 	Ingo
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

