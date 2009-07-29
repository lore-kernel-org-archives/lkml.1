Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZG2Mfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZG2Mfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZG2Mfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:35:52 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58926 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZG2Mfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:35:52 -0400
Date: Wed, 29 Jul 2009 21:35:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Ian Molton <ian@mnementh.co.uk>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
Message-ID: <20090729123545.GA23683@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Ian Molton <ian@mnementh.co.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
	Magnus Damm <damm@opensource.se>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> <4A6F033B.7030302@mnementh.co.uk> <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com> <20090729115817.GA12223@rakim.wolfsonmicro.main> <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 09:27:54PM +0900, Magnus Damm wrote:
> On Wed, Jul 29, 2009 at 8:58 PM, Mark
> Brown<broonie@opensource.wolfsonmicro.com> wrote:
> > Looking at the original patch I'm not sure exactly why it runs into
> > clock API issues so I'm not sure if this is a relevant concern or not
> > here but I'm mentioning it since I'd kind of expect an impact on the
> > SoCs from addressing it due to the way the clock API functions are
> > currently provided.
> 
> In my opinion this patch has nothing to do with the clock framework.
> 
> But fixing up clocklib properly would certainly be beneficial for
> everyone. Holding the driver hostage until clocklib is upstream
> however, that's just silly.
> 
It also presupposes that people want clocklib upstream. The last time I
saw it pass through my inbox, I wasn't convinced that it really bought us
anything. The ARM clkdev thing on the other hand is something I plan to
drag in on the SH side as well, but that too is a separate thing.

If folks are of the mindset that the current patch is a misuse of the
clock framework, then the objection needs to be specifically noted. I'm
willing to make concessions on the clock framework side if Ian has
problems with the current scheme, but I am not at all convinced of the
relative merit of clocklib, or holding drivers hostage to such. 
