Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXIRQxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXIRQxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXIRQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:53:08 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:3122 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbXIRQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:53:07 -0400
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 12:53:06 EDT
Message-ID: <46EFFEBC.9020706@linuxtv.org>
From: mkrufky@linuxtv.org
To: sam@ravnborg.org
Cc: nix.or.die@googlemail.com, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] modpost errors ( Re: 2.6.23-rc6-mm1)
Date: Tue, 18 Sep 2007 12:37:16 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20070918155639.GC26539@uranus.ravnborg.org>
x-originalarrivaltime: 18 Sep 2007 16:19:59.0474 (UTC) FILETIME=[C24EB520:01C7FA0F]
user-agent: Thunderbird 2.0.0.6 (Windows/20070728)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Please cc: relevant people.
>
> On Tue, Sep 18, 2007 at 05:43:35PM +0200, Gabriel C wrote:
>   
>> Hi,
>>
>> I get modpost errors here :
>>
>> ...
>>
>> ERROR: "dvb_dmx_init" [drivers/media/video/video-buf-dvb.ko] undefined!
>> ERROR: "dvb_unregister_adapter" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_register_frontend" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_unregister_frontend" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_net_release" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_frontend_detach" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_dmxdev_release" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_dmx_swfilter" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_net_init" [drivers/media/video/video-buf-dvb.ko] undefined!
>> ERROR: "dvb_dmx_release" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_register_adapter" [drivers/media/video/video-buf-dvb.ko]
undefined!
>> ERROR: "dvb_dmxdev_init" [drivers/media/video/video-buf-dvb.ko]
undefined!
>>     
>
> dvb issue so dvb added.
>
>   
>> ERROR: "mt2131_attach" [drivers/media/video/cx23885/cx23885.ko]
undefined!
>> ERROR: "s5h1409_attach" [drivers/media/video/cx23885/cx23885.ko]
undefined!
>>     
>
> Was not sure who maintain this stuff..
> It's not in the git-tree I had around.

Sam,

This stuff is in -mm only right now.

It was a dependency problem, where a new driver (cx23885) is missing the 
dependency on DVB_CORE.

The fix is in this changeset:

http://linuxtv.org/hg/~mkrufky/build-fix/rev/67acaa106a99

Mauro,

Please pull from:

http://linuxtv.org/hg/~mkrufky/build-fix

for:

- VIDEO_CX23885 depends on DVB_CORE

 Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Regards,

Mike Krufky
