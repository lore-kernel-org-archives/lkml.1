Return-Path: <linux-kernel-owner+w=401wt.eu-S938606AbXHICn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938606AbXHICn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764011AbXHICnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:43:17 -0400
Received: from lazybastard.de ([212.112.238.170]:60287 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761941AbXHICnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:43:16 -0400
Date: Thu, 9 Aug 2007 04:39:20 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch 18/18] include/linux/Kbuild
Message-ID: <20070809023920.GB3321@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org> <20070808162447.GT15319@lazybastard.org> <20070809001913.GA10044@infradead.org> <20070809023217.GA3321@lazybastard.org> <20070809023906.GA18792@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070809023906.GA18792@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 August 2007 03:39:06 +0100, Christoph Hellwig wrote:
> On Thu, Aug 09, 2007 at 04:32:17AM +0200, J??rn Engel wrote:
> > On Thu, 9 August 2007 01:19:13 +0100, Christoph Hellwig wrote:
> > > On Wed, Aug 08, 2007 at 06:24:47PM +0200, J??rn Engel wrote:
> > > > --- linux-2.6.21logfs/include/linux/Kbuild~logfs	2007-08-08 02:57:37.000000000 +0200
> > > > +++ linux-2.6.21logfs/include/linux/Kbuild	2007-08-08 02:57:37.000000000 +0200
> > > > @@ -101,6 +101,7 @@ header-y += jffs2.h
> > > >  header-y += keyctl.h
> > > >  header-y += limits.h
> > > >  header-y += lock_dlm_plock.h
> > > > +header-y += logfs.h
> > > 
> > > That file doesn't define any kind of user<->kernel interface and thus should
> > > not be exported.
> > 
> > mklogfs needs the header.  Does that not qualify?
> 
> No.  We been through this example (filesystem layouts) a few times.
> It's of course not a kernel interface, and sharing it actually is harmfull,
> because it means you can't change the structure layout for your filesystem
> definition anymore, which unlike an actual ondisk change happens very
> frequently, e.g. when introducing new unions keyed off a feature flag,
> or similar things.  So please ship a copy with your userspace tools
> package.

Fair enough.  Does the file still make sense in include/linux/ then?

Jörn

-- 
All art is but imitation of nature.
-- Lucius Annaeus Seneca
