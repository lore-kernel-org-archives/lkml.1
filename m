Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYDVUii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYDVUii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYDVUia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:38:30 -0400
Received: from xenotime.net ([66.160.160.81]:59039 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753962AbYDVUi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:38:29 -0400
Date: Tue, 22 Apr 2008 13:38:28 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
In-Reply-To: <20080422203334.GA9809@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0804221337550.19817@shark.he.net>
References: <1208895950.24124.9.camel@brick> <20080422203334.GA9809@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Russell King wrote:

> That was my initial approach as well, which got shot down by Andrew
> Morton and others as being unacceptable.

where?  why?

Seems like we need to push back on that part.

> On Tue, Apr 22, 2008 at 01:25:50PM -0700, Harvey Harrison wrote:
> > Limit this driver to ARCH_PXA, noticed by breakage on allyesconfig
> > builds on 32-bit x86.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Linus, please apply and Russell can fix it up however he likes later
> > in the week.  Many people are hitting this.
> > 
> >  drivers/mfd/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 2566479..bd29c61 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -32,6 +32,7 @@ config HTC_EGPIO
> >  
> >  config HTC_PASIC3
> >  	tristate "HTC PASIC3 LED/DS1WM chip support"
> > +	depends on ARCH_PXA
> >  	help
> >  	  This core driver provides register access for the LED/DS1WM
> >  	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
> > -- 
> > 1.5.5.144.g3e42

-- 
~Randy
