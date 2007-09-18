Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbXIRPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbXIRPrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXIRPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:47:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:38693 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212AbXIRPrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WiPduIQoPypXZ6BY427H2vaAE8rgi90b9HllmSfZPr0QbqfCdgbHhYdvRCmvmS7WVC9QugA+5BdOA6PREeg2Qi9i2iMdDAQaxF4+YhQ0l2SOxFCqTIvgRuiJ3OmL+eNRslVt3UyiImcHdqZP1QnQ4oIn6SAVWlqFLxlyjWdIAok=
Message-ID: <46EFF227.4080603@googlemail.com>
Date: Tue, 18 Sep 2007 17:43:35 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: modpost errors ( Re: 2.6.23-rc6-mm1)
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get modpost errors here :

...

ERROR: "dvb_dmx_init" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_unregister_adapter" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_register_frontend" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_unregister_frontend" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_net_release" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_frontend_detach" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmxdev_release" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmx_swfilter" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_net_init" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmx_release" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_register_adapter" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmxdev_init" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "mt2131_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
ERROR: "s5h1409_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
  CC      arch/i386/boot/mca.o
  CC      arch/i386/boot/memory.o
  CC      arch/i386/boot/pm.o
make[1]: *** [__modpost] Fehler 1
make: *** [modules] Fehler 2

...


config there : http://194.231.229.228/MM/2.6.23-rc6-mm1/config-modpost-errors


Regards,

Gabriel
