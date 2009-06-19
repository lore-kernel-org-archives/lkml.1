Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZFSVXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZFSVXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZFSVXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:23:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbZFSVXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:23:18 -0400
Date: Fri, 19 Jun 2009 23:22:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: James Morris <jmorris@namei.org>, Joseph Cihula <joseph.cihula@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hpa@zytor.com, andi@firstfloor.org,
       Chris Wright <chrisw@sous-sol.org>, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090619212255.GB2229@elf.ucw.cz>
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org> <20090619150514.GE1389@ucw.cz> <33858.1245433922@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33858.1245433922@turing-police.cc.vt.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > Linux support for Intel(R) Trusted Execution Technology.
> > > 
> > > > Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
> > > > Signed-off-by:  Shane Wang <shane.wang@intel.com>
> > > > Signed-off-by:  Gang Wei <gang.wei@intel.com>
> > > 
> > > Reviewed-by: James Morris <jmorris@namei.org>
> > > 
> > > There have been no comments on this since you posted it, so we might 
> > > assume there are no further technical issues.
> > 
> > I believe the code at best useless and at worst dangerous. We don't
> > merge useless code to the kernel.
> > 
> > What are non-evil uses of this code?
> 
> Yes, most of the uses contemplated for this are for evil DRM schemes.  On the
> other hand, the code is equally useful to help make sure that mo miscreant has
> snuck evil DRM (or other evil code) in behind my back.
> 
> "Somebody has screwed with this kernel image, and you're not booting what you
> thought you were booting."
> 
> Seems worth it to me.

Unfortunately, I do not think you can boot linux kernel under TXT
sandbox. (Is there some code that you can boot under TXT sandbox? If
so, where?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
