Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZHXMus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZHXMus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 08:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZHXMur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 08:50:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64212 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZHXMur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:50:47 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+kkgUe1GnV9tnk+t1njo0L
Date: Mon, 24 Aug 2009 15:50:27 +0300
From: Tony Lindgren <tony@atomide.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v3] ASoC: OMAP: Enhance OMAP1510 DMA progress
	software counter
Message-ID: <20090824125026.GI7069@atomide.com>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl> <200908110107.11485.jkrzyszt@tis.icnet.pl> <200908112144.30731.jkrzyszt@tis.icnet.pl> <20090817122605.0b240ea7.jhnikula@gmail.com> <20090817100313.GA5756@rakim.wolfsonmicro.main> <4A8AAFAD.9050705@tis.icnet.pl> <20090818134540.GB24620@sirena.org.uk> <20090818195701.6f260d33.jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818195701.6f260d33.jhnikula@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jarkko Nikula <jhnikula@gmail.com> [090818 19:55]:
> On Tue, 18 Aug 2009 14:45:41 +0100
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Tue, Aug 18, 2009 at 03:42:05PM +0200, Janusz Krzysztofik wrote:
> > 
> > > And now, how is the patch 1/3 supposed to get into the mainline? Whom  
> > > should I ping from time to time to get it integrated? If not then, as  
> > > you know for sure, applying patch 2/3 whithout 1/3 will result in ASoC  
> > > support for OMAP1510 broken.
> > 
> > Normally the OMAP tree, though that's possibly a bit tricky due to the
> > ARM tree closing early.  If Tony's OK with merging via the ALSA tree we
> > could also apply the ARM patch there?
> 
> I would say that it's better to keep in Tony's hand since otherwise
> there can be risk for DMA code being out-of-sync as there are quite
> frequent other PM, OMAP4, errata, etc. patches coming into it.
> 
> Of course it means that OMAP1510 audio is broken until the patch 1/3 is
> merged but probably patch can be merged as a fix if merge window is
> missed.

Already replied in another part of the thread, but just for the archives:

Since we don't have other dma or mcbsp patches going in right now,
let's merge these all via the alsa list so audio keeps working.

Regards,

Tony
