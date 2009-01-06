Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZAFMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZAFMnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZAFMne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:43:34 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:39568 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZAFMnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:43:33 -0500
Date: Tue, 6 Jan 2009 13:43:31 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Pavel Machek <pavel@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci-quirks: HP hides SMBus controller in Compaq nx9500 laptops
Message-ID: <20090106124331.GA7153@rere.qmqm.pl>
References: <20081223215407.GB32525@rere.qmqm.pl> <19700101064603.GA1406@ucw.cz> <200901051119.20684.jbarnes@virtuousgeek.org> <20090105200221.GA26115@rere.qmqm.pl> <20090106084121.GA9347@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106084121.GA9347@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 09:41:21AM +0100, Pavel Machek wrote:
> > rechot ~ # i2cdetect -a 0
> > WARNING! This program can confuse your I2C bus, cause data loss and worse!
> > I will probe file /dev/i2c-0.
> > I will probe address range 0x00-0x7f.
> > Continue? [Y/n] y
> >           0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> >      00: -- -- -- -- -- -- -- -- 08 -- -- -- -- -- -- --
> >      10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> >      20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> >      30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> >      40: -- -- -- -- 44 -- -- -- -- -- -- -- -- -- -- --
> >      50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> >      60: -- -- -- -- -- -- -- -- -- 69 -- -- -- -- -- --
> >      70: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 
> > I observed no ill effects after scanning the bus, but YMMV.
> > 
> > Using the bus is probably not a good idea if the SMM code is really using
> > it, and so it might be better if this patch lies in the archives for now.
> > After I get the BIOS flashing to work I'll look into this.
> I'm not saying SMM code _does_ use it... I just don't know, and
> reading DSDT will not tell me (or you).

But it is likely, isn't it? By 'looking into this' I meant that I will
take the BIOS apart again, disassemble it and check whatever it is that
the vendor is hiding. I'll repost this patch if it turns out there's
nothing to worry about.

Anyway - if someone wants to do the digging sooner, I can share
what I already know (including some documentation, tools and BIOS images
I found using Google).

Best Regards,
Michal Miroslaw

