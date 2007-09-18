Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXIRPz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXIRPz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbXIRPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:55:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46776 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301AbXIRPzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:55:15 -0400
Date: Tue, 18 Sep 2007 17:56:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: modpost errors ( Re: 2.6.23-rc6-mm1)
Message-ID: <20070918155639.GC26539@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46EFF227.4080603@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EFF227.4080603@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please cc: relevant people.

On Tue, Sep 18, 2007 at 05:43:35PM +0200, Gabriel C wrote:
> Hi,
> 
> I get modpost errors here :
> 
> ...
> 
> ERROR: "dvb_dmx_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_unregister_adapter" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_register_frontend" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_unregister_frontend" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_net_release" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_frontend_detach" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmxdev_release" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmx_swfilter" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_net_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmx_release" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_register_adapter" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmxdev_init" [drivers/media/video/video-buf-dvb.ko] undefined!

dvb issue so dvb added.

> ERROR: "mt2131_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
> ERROR: "s5h1409_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!

Was not sure who maintain this stuff..
It's not in the git-tree I had around.

	Sam


>   CC      arch/i386/boot/mca.o
>   CC      arch/i386/boot/memory.o
>   CC      arch/i386/boot/pm.o
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2
> 
> ...
> 
> 
> config there : http://194.231.229.228/MM/2.6.23-rc6-mm1/config-modpost-errors
> 
> 
> Regards,
> 
> Gabriel
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
