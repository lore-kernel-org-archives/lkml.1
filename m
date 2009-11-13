Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbZKMUok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbZKMUok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbZKMUoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:44:34 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50696 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbZKMUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:44:30 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LU3CGa9dlBHxPWb1FoYPR
Date: Fri, 13 Nov 2009 12:44:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       vikram pandita <vikram.pandita@ti.com>
Subject: Re: linux-next: manual merge of the sound tree with the omap tree
Message-ID: <20091113204429.GE3684@atomide.com>
References: <20091113131947.03d1b259.sfr@canb.auug.org.au>
 <20091113123901.GB30966@sirena.org.uk>
 <s5h1vk2po9n.wl%tiwai@suse.de>
 <20091113131148.GC21516@rakim.wolfsonmicro.main>
 <s5hzl6qo9c9.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzl6qo9c9.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai <tiwai@suse.de> [091113 05:13]:
> At Fri, 13 Nov 2009 13:11:48 +0000,
> Mark Brown wrote:
> > 
> > On Fri, Nov 13, 2009 at 02:06:44PM +0100, Takashi Iwai wrote:
> > > Mark Brown wrote:
> > 
> > > > into the OMAP tree to resolve this.  There's some older ASoC changes in
> > > > there to ensure the patches applied but I'm happy for you to carry those
> > > > providing Takashi is.
> > 
> > > I can merge the tree above to for-next branch of sound git tree, too.
> > > In that way, we can keep asoc branches clean.
> > 
> > I believe that creates the same problem both ways :/ .  If we merge
> > OMAP->sound we may as well put it on the ASoC topic branch, it'll
> > probably be helpful for people doing OMAP work anyway.
> 
> OK, in both ways I don't care...

I think this should get resolved if I git cherry-pick the following
commits to linux-omap for-next:

MFD: twl4030: add twl4030_codec MFD as a new child to the core
0b83ddebc6e884dc0221358cf68c461520fbdd8e

OMAP: Platform support for twl4030_codec MFD
f8d9aad96d0d7b57d0bf2e4de21fdda3a42f4449

OMAP: Configure audio_mclk for twl4030-codec MFD
953e2f3d272db9db6671ad4f4244820557a71cf7

Then I can tweak the sdp and zoom patches accordingly. So let's try
that first, I'll try it out today.

Regards,

Tony

