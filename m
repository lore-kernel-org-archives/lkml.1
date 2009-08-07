Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbZHGIwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZHGIwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZHGIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:52:44 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63241 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbZHGIwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:52:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Jarkko Nikula <jhnikula@gmail.com>
Subject: Re: [alsa-devel] [PATCH][2.6.31-rc5] ARM: OMAP: McBSP: Fix ASoC on OMAP1510 by fixing API of omap_mcbsp_start/stop
Date: Fri, 7 Aug 2009 11:51:43 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.30-gentoo-r4; KDE/4.2.4; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1249628387-7372-1-git-send-email-jhnikula@gmail.com> <200908071130.54337.peter.ujfalusi@nokia.com> <20090807114757.0067a707.jhnikula@gmail.com>
In-Reply-To: <20090807114757.0067a707.jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908071151.44083.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 07 Aug 2009 08:51:50.0254 (UTC) FILETIME=[4DB318E0:01CA173C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 11:47:57 ext Jarkko Nikula wrote:
> On Fri, 7 Aug 2009 11:30:54 +0300
>
> Peter Ujfalusi <peter.ujfalusi@nokia.com> wrote:
> > Looks nice, but I would have done it a bit differently...
>
> ...
>
> > > -void omap_mcbsp_start(unsigned int id);
> > > -void omap_mcbsp_stop(unsigned int id);
> > > +void omap_mcbsp_start(unsigned int id, int tx, int rx);
> > > +void omap_mcbsp_stop(unsigned int id, int tx, int rx);
> >
> > void omap_mcbsp_start(unsigned int id, int dir);
> > void omap_mcbsp_stop(unsigned int id, int dir);
>
> Valid point and cleans up a bit the ALSA SoC part of the patch.
> However I didn't want to limit this generic arch/arm/plat-omap/mcbsp.c
> into audio use case only. My change still allows to start transmitter
> and receiver exactly at the same time. Might be worth if the
> generic McBSP driver is used for something else than audio.

Good point.

-- 
Péter
