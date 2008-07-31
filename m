Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYGaQ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYGaQ60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYGaQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:57:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYGaQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:57:54 -0400
Subject: Re: [patch 2/4] Configure out file locking features
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080731164918.GE20212@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com>
	 <20080731093220.969460336@free-electrons.com>
	 <20080731135319.GA20212@cs181140183.pp.htv.fi>
	 <20080731162007.285938e0@surf>
	 <20080731153757.GB20212@cs181140183.pp.htv.fi>
	 <20080731182616.4c20f0db@surf>
	 <20080731164918.GE20212@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 31 Jul 2008 17:57:11 +0100
Message-Id: <1217523431.3454.283.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 19:49 +0300, Adrian Bunk wrote:
> On Thu, Jul 31, 2008 at 06:26:16PM +0200, Thomas Petazzoni wrote:
> > Le Thu, 31 Jul 2008 18:37:57 +0300,
> > Adrian Bunk <bunk@kernel.org> a écrit :
> > 
> > > I'm just not a fan of adding config options for each few kB of code - 
> > > we have to maintain them and the more complex the configuration
> > > becomes the more often it breaks.
> > 
> > I'm not a fan of these too, but are there other solutions ?
> 
> There are many things that can be done to reduce the kernel size or try 
> to minimize the growth of the kernel.
> 
> E.g. working on --combine -fwhole-program (where David once had 
> preliminary patches for the per-module approach) might be better.

Yeah, I'm planning to dig that out again and play with it some time
soon. The Kbuild issues were too scary at the time, but I'm less
frightened of it these days...

Segher has also been looking at it, and reported quite a useful win when
he used it to combine arch/$ARCH/mm and mm/, and arch/$ARCH/kernel and
kernel/.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



