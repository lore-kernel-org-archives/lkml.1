Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZBCS4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZBCS4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZBCS42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:56:28 -0500
Received: from smtp4.welho.com ([213.243.153.38]:36961 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbZBCS42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:56:28 -0500
Date: Tue, 3 Feb 2009 20:56:25 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Risto Suominen <risto.suominen@gmail.com>, Alex Kern <alex.kern@gmx.de>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] atyfb: fix distorted image on
	PowerMacs
Message-ID: <20090203185624.GC22401@sci.fi>
Mail-Followup-To: Risto Suominen <risto.suominen@gmail.com>,
	Alex Kern <alex.kern@gmx.de>, linux-kernel@vger.kernel.org,
	benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net
References: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com> <20090122201204.GD4996@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090122201204.GD4996@sci.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 10:12:04PM +0200, Ville Syrjälä wrote:
> On Thu, Jan 22, 2009 at 08:22:48PM +0200, Risto Suominen wrote:
> > Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
> > and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
> > columns in their framebuffer image. This seems to depend on a value (4) read
> > from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
> > be written to the chip. This patch uses a value calculated by aty_init_pll_ct
> > instead, as a starting point.
> 
> AFAICS it should be the right thing to do on other systems too. I have
> a good collection of mach64 pci cards and laptops so I'll try to find
> some time next week to test that theory on x86.

Well, the experiment failed on the first Mobility I tried. The FIFO
calculations aren't obvious from the code and there's no mention how
to actually calculate them in the programming guide. So I guess special
casing powermacs is the best way forward.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
