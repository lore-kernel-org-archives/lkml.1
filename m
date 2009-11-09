Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZKIWBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZKIWBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZKIWBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:01:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59559 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbZKIWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:01:32 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uyf3fg2QrPXwAEdSUdK8E
Date: Mon, 9 Nov 2009 14:01:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 2/4 v2] OMAP: Configure audio_mclk for
 twl4030-codec MFD
Message-ID: <20091109220131.GH23952@atomide.com>
References: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257321500-27049-2-git-send-email-peter.ujfalusi@nokia.com>
 <1257321500-27049-3-git-send-email-peter.ujfalusi@nokia.com>
 <200911090946.46576.peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911090946.46576.peter.ujfalusi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Peter Ujfalusi <peter.ujfalusi@nokia.com> [091108 23:46]:
> Hello Tony,
> 
> On Wednesday 04 November 2009 09:58:18 Ujfalusi Peter (Nokia-D/Tampere) wrote:
> > audio_mclk value is going to be handled by the
> > twl4030-codec MFD driver, configure the correct
> > value for boards, which is using the twl4030 audio.
> > 
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
> > ---
> >  arch/arm/mach-omap2/board-3430sdp.c      |    1 +
> >  arch/arm/mach-omap2/board-omap3beagle.c  |    1 +
> >  arch/arm/mach-omap2/board-omap3evm.c     |    1 +
> >  arch/arm/mach-omap2/board-omap3pandora.c |    1 +
> >  arch/arm/mach-omap2/board-overo.c        |    1 +
> >  arch/arm/mach-omap2/board-zoom2.c        |    1 +
> >  6 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/board-3430sdp.c
> >  b/arch/arm/mach-omap2/board-3430sdp.c index 4f91f7a..9afd957 100644
> > --- a/arch/arm/mach-omap2/board-3430sdp.c
> > +++ b/arch/arm/mach-omap2/board-3430sdp.c
> > @@ -415,6 +415,7 @@ static struct twl4030_codec_audio_data sdp3430_audio =
> >  { };
> > 
> >  static struct twl4030_codec_data sdp3430_codec = {
> > +	.audio_mclk = 26000000,
> >  	.audio = &sdp3430_audio,
> >  };
> > 

<snip>
 
> Can you take a look at this patch?
> The rest of the series has already got Ack from Samuel and Mark, and only your 
> verdict for the OMAP part is missing.

Looks good to me. It seems like it's best to queue this along
with the related ASoC patches.

Acked-by: Tony Lindgren <tony@atomide.com>

