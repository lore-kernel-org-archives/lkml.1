Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0BBLuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:50:37 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:51443 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0BBLue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:50:34 -0500
Subject: Re: linux-next: sound tree build failure
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20100202221743.1dbcad11.sfr@canb.auug.org.au>
References: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
	 <20100202102609.GA6566@rakim.wolfsonmicro.main>
	 <20100202213732.586a3566.sfr@canb.auug.org.au>
	 <20100202105800.GE6566@rakim.wolfsonmicro.main>
	 <20100202221743.1dbcad11.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 11:50:30 +0000
Message-ID: <1265111430.4194.144.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 2010-02-02 at 22:17 +1100, Stephen Rothwell wrote:
> Hi Mark,
> 
> On Tue, 2 Feb 2010 10:58:00 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> >
> > On Tue, Feb 02, 2010 at 09:37:32PM +1100, Stephen Rothwell wrote:
> > 
> > > The sound tree is merged before the mfd tree, and the commit that adds
> > > those is only in the mfd tree.  So the sound tree, on its own, is
> > > broken.  This driver will only build if you merge the mfd tree as well.
> > 
> > Ah, you're doing builds after each individual merge.  It might help to
> 
> Always have ...
> 

I wonder if it would be possible to re-order the merge sequence so that
similar inter tree dependencies are less likely to cause -next build
failures in the future.  I guess atm lots of driver trees can depend on
MFD (e.g. regulator, sound, rtc, backlight, led, watchdog, etc) so it
may be good to move it up the order.

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

