Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYGVUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYGVUdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYGVUdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:33:02 -0400
Received: from xenotime.net ([66.160.160.81]:35968 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751394AbYGVUdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:33:00 -0400
Date: Tue, 22 Jul 2008 13:32:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: bjorn.helgaas@hp.com, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build error (PNP/IXJ)
Message-Id: <20080722133257.7362b9f1.rdunlap@xenotime.net>
In-Reply-To: <20080722201930.GB14846@cs181140183.pp.htv.fi>
References: <20080722102739.61462b04.randy.dunlap@oracle.com>
	<20080722173957.GA14846@cs181140183.pp.htv.fi>
	<20080722124152.facaa724.rdunlap@xenotime.net>
	<20080722201930.GB14846@cs181140183.pp.htv.fi>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 23:19:30 +0300 Adrian Bunk wrote:

> On Tue, Jul 22, 2008 at 12:41:52PM -0700, Randy Dunlap wrote:
> > On Tue, 22 Jul 2008 20:39:57 +0300 Adrian Bunk wrote:
> > 
> > > On Tue, Jul 22, 2008 at 10:27:39AM -0700, Randy Dunlap wrote:
> > > > Hi,
> > > > 
> > > > I'm seeing several build errors in linux-next-20080722 that I haven't
> > > > seen previously, although I don't know what changed to cause this.
> > > > 
> > > > They are all basically the same, in ixj (drivers/telephony/ixj*), when
> > > > CONFIG_PNP=n, and CONFIG_PHONE_IXJ=y or =m (so the actual error message
> > > > varies depending on IXJ=y or =m):
> > > > 
> > > > IXJ=y:
> > > > ixj.c:(.text+0x329d98): undefined reference to `pnp_get_resource'
> > > > or IXJ=m:
> > > > ERROR: "pnp_get_resource" [drivers/telephony/ixj.ko] undefined!
> > > > 
> > > > 
> > > > Suggestions?
> > > 
> > > Please send a .config
> > 
> > attached.  (IXJ=m)
> 
> Works for me with gcc 4.3.1.
> Which gcc version are you using?

gcc (GCC) 4.2.1 (SUSE Linux)

> Does disabling CONFIG_OPTIMIZE_INLINING fix it for you?

Hmpf.  Yes, it sure does.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
