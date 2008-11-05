Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbYKEQ0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbYKEQ0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYKEQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:26:14 -0500
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:26513 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752271AbYKEQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:26:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=p3gV+Muv5sMeisymqI6HE4igoiHdy+6tQgFJnNAbDXa3KhvCvZRHnv9+zWnohgqlN31ZF8yM4SlKf+5NxGceiqrI791uuvA0xpzGJadpdDGjx1qmfD9mgzPQjWwLCklefTJywRHjcyvi4a8AmD6/IPhLtkoCtuZ5PMWaNZ6BMxQ=;
X-YMail-OSG: 1rLMerQVM1k_367nGok2HLupGniYzOUWO_ufsGnxJf5ja02F92CZJsDNI5wqXIAZDmIsnvenC7vx7pgFJGe94i6fs8TYb4t9sQ7aN9fCRrW.jVRAzC0atlMbRM8sa9LuceUhRJw__pe5T0CLLbHLRfgOL3.9IUk4SOOo007mrylqNXGKeHMQkxKfDQ--
Date: Wed, 5 Nov 2008 08:26:12 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
To: Hitoshi Mitake <mitake@clustcom.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       ktaka@clustcom.com
In-Reply-To: <20081105222911.d76e7e1c.mitake@clustcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <413709.12821.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Hitoshi Mitake <mitake@clustcom.com> wrote:

> On Mon, 20 Oct 2008 16:32:28 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 17 Oct 2008 15:39:45 -0600
> > dougthompson@xmission.com wrote:
> > 
> > > From: Hitoshi Mitake <mitake@clustcom.com>
> > > 
> > > I wrote a new module for Intel X38 chipset.
> > > This chipset is very similar to Intel 3200 chipset,
> > > but there are some different points,
> > > so I copyed i3200_edac.c and modified.
> > > 
> > > This is a Intel's web page describing this chipset.
> > > http://www.intel.com/Products/Desktop/Chipsets/X38/X38-overview.htm
> > > 
> > > I've tested this new module with broken memory,
> > > and it seems working well.
> > > 
> > > This is a patch, please use.
> > > Hitoshi
> > > 
> > > Signed-off-by: Hitoshi Mitake <mitake@clustcom.com>
> > > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> > > ---
> > > 
> > > Index: linux-2.6.27/drivers/edac/Kconfig
> > > ===================================================================
> > > --- linux-2.6.27.orig/drivers/edac/Kconfig
> > > +++ linux-2.6.27/drivers/edac/Kconfig
> > > @@ -102,6 +102,13 @@ config EDAC_I3000
> > >  	  Support for error detection and correction on the Intel
> > >  	  3000 and 3010 server chipsets.
> > >  
> > > +config EDAC_X38
> > > +	tristate "Intel X38"
> > > +	depends on EDAC_MM_EDAC && PCI && X86
> > > +	help
> > > +	  Support for error detection and correction on the Intel
> > > +	  X38 server chipsets.
> > 
> > Is this truly X86, or will this driver only ever be used on x86_64 kernels?
> 
> I didn't know readq() of x86_64, and missed the case
> to use this driver on x86_64. Thank you.
> 
> I wrote new version of this driver and tested. It works well.
> This is replacement for old version.
> Or should I send diff of two versions?


I would suggest sending a diff of what is now in the -mm tree to what it should be.

doug t



W1DUG
