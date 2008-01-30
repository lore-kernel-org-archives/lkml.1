Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYA3AYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYA3AYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYA3AYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:24:44 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56413 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYA3AYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:24:43 -0500
Date: Wed, 30 Jan 2008 02:25:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080130002514.GA1802@does.not.exist>
References: <1201641765.18773.35.camel@dv> <20080129225701.GS8767@does.not.exist> <1201650267.18773.118.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1201650267.18773.118.camel@dv>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 06:44:27PM -0500, Pavel Roskin wrote:
> On Wed, 2008-01-30 at 00:57 +0200, Adrian Bunk wrote:
> > On Tue, Jan 29, 2008 at 04:22:45PM -0500, Pavel Roskin wrote:
> > > Hello!
> > > 
> > > It have come to my attention that a patch has been committed to the
> > > kernel with the explicit purpose of tainting ndiswrapper - the kernel
> > > module allowing Windows NDIS drivers for Ethernet and Wireless cards to
> > > be used by the kernel.
> > >...
> > > Just to reiterate some points from the old discussion:
> > >...
> > > - no copyright violation is involved, as Windows drivers are not derived
> > > from Linux sources
> > >...
> > 
> > It is interesting that someone posting with an @gnu.org address claims
> > that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> > not a copyright violation.
> 
> No, I'm representing myself only.  I don't think you represent all
> kernel developers when posting from the kernel.org address.

I'm not using my @kernel.org address except for kernel issues and I'm 
not using a company address in linux-kernel discussions.

Mailing lists of a project or a company are something completely 
different from using a project or company address outside of the 
project.

> I'm actually surprised that you are raising this issue.  If the
> motivation to ban ndiswrapper is based on the copyright law, doesn't it
> meant that we have DRM in the kernel now?  Is Linux going to enforce
> copyright laws across the world?
> 
> > Is it an official statement of the FSF that such linking is considered 
> > legal?
> 
> Absolutely not.
> 
> > (RMS added to Cc)
> 
> I, for one, would welcome an informed position of the FSF.  It may have
> interesting implications for Wine, ReactOS, mplayer, qemu, Java and many
> other programs loading non-free compiled code at the run time.

Wine is licenced under the terms of the LGPL.

ReactOS is licenced under the terms of the GPL with a licence 
exception for runtime linking of non-free modules.

QEMU is licenced under the terms of the GPL with a licence exception for 
runtime linking with libqemu.a.

GNU classpath (and libgcj) are licenced under the terms of the GPL with 
a licence exception for runtime linking with it.

As you can see, all of the above explicitely address this issue.

The only program from your list that has a fishy licencing is mplayer.

> Regards,
> Pavel Roskin

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

