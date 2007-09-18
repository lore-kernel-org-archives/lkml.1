Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXIRWFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXIRWFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXIRWF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:05:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54635 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbXIRWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:05:28 -0400
Subject: Re: [v4l-dvb-maintainer] modpost errors ( Re: 2.6.23-rc6-mm1)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: mkrufky@linuxtv.org
Cc: sam@ravnborg.org, nix.or.die@googlemail.com,
       v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <46EFFEBC.9020706@linuxtv.org>
References: <46EFFEBC.9020706@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Sep 2007 19:06:11 -0300
Message-Id: <1190153171.7883.1.camel@areia>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied at my -git tree.

Cheers,
Mauro.

Em Ter, 2007-09-18 às 12:37 -0400, mkrufky@linuxtv.org escreveu:
> Sam Ravnborg wrote:
> > Please cc: relevant people.
> >
> > On Tue, Sep 18, 2007 at 05:43:35PM +0200, Gabriel C wrote:
> >   
> >> Hi,
> >>
> >> I get modpost errors here :
> >>
> >> ...
> >>
> >> ERROR: "dvb_dmx_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> >> ERROR: "dvb_unregister_adapter" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_register_frontend" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_unregister_frontend" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_net_release" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_frontend_detach" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_dmxdev_release" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_dmx_swfilter" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_net_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> >> ERROR: "dvb_dmx_release" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_register_adapter" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >> ERROR: "dvb_dmxdev_init" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> >>     
> >
> > dvb issue so dvb added.
> >
> >   
> >> ERROR: "mt2131_attach" [drivers/media/video/cx23885/cx23885.ko]
> undefined!
> >> ERROR: "s5h1409_attach" [drivers/media/video/cx23885/cx23885.ko]
> undefined!
> >>     
> >
> > Was not sure who maintain this stuff..
> > It's not in the git-tree I had around.
> 
> Sam,
> 
> This stuff is in -mm only right now.
> 
> It was a dependency problem, where a new driver (cx23885) is missing the 
> dependency on DVB_CORE.
> 
> The fix is in this changeset:
> 
> http://linuxtv.org/hg/~mkrufky/build-fix/rev/67acaa106a99
> 
> Mauro,
> 
> Please pull from:
> 
> http://linuxtv.org/hg/~mkrufky/build-fix
> 
> for:
> 
> - VIDEO_CX23885 depends on DVB_CORE
> 
>  Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Regards,
> 
> Mike Krufky

