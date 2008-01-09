Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYAISXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYAISXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYAISXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:23:35 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49187 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbYAISXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:23:34 -0500
Date: Wed, 9 Jan 2008 20:22:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Christer Weinigel <christer@weinigel.se>,
       "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@qumranet.com>,
       Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
	I/O delay override.
Message-ID: <20080109182250.GB4394@does.not.exist>
References: <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com> <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com> <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com> <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com> <20080109063052.48a5709c@weinigel.se> <4784E7E1.4060308@keyaccess.nl> <1199902644.7369.355.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1199902644.7369.355.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:17:24AM -0800, Zachary Amsden wrote:
> On Wed, 2008-01-09 at 16:27 +0100, Rene Herman wrote:
> > On 09-01-08 06:30, Christer Weinigel wrote:
> > I'd not expect very time crtical. The current outb_p use gives a delay 
> > somewhere between .5 and 2 microseconds as per earlier survey meaning a 
> > udelay(1) or 2 would be enough -- again, at the point that udelay() is sensible.
> > 
> > New machines don't use the legacy PIC anymore anyway.
> > 
> > > The floppy controller code uses outb_p.  Even though there might be
> > > floppy controllers on modern systems, I'd rather leave the floppy code
> > > alone since it's supposed to be very fragile.  If you still use
> > > floppies you deserve what you get.
> > 
> > Floppies forever. In practice, leaving it alone isn't going to matter, but 
> > in that same practice changing it to udelay() probably doesn't either. The 
> > ones to leave alone are the ones that are clumsy/impossible to test and the 
> > ones such as in NIC drivers that were specifically tuned.
> 
> I'm speaking specifically in terms of 64-bit platforms here.  Shouldn't
> we unconditionally drop outb_p doing extra port I/O on 64-bit
> architectures?  Especially considering they don't even have an ISA bus
> where the decode timing could even matter?
>...

I don't think the latter statement was true - AFAIR there are Alphas 
with ISA slots.

> Agree.
> 
> Zach

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

