Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbXIAQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbXIAQuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbXIAQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:50:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60921 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbXIAQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:50:06 -0400
Date: Sat, 1 Sep 2007 22:33:07 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eugene Teo <eugeneteo@kernel.sg>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: 2.6.23-rc4-mm1: geode fb compile error
In-Reply-To: <20070901141845.GG9260@stusta.de>
Message-ID: <alpine.LFD.0.999.0709012220370.20781@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <20070901141845.GG9260@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Sep 2007, Adrian Bunk wrote:
> 
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc3-mm1:
> >...
> > +drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
> > 
> >  Fix drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch
> >...
> 
> This patch doesn't fix 
> drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch, together 
> they break the compilation (2 - 1 - 1 = 0 < 1):

True, both (Eugene's and mine) patches are different/independent patches
to remove the "unused variable" warning. Both seem to have got included in
-mm with the result that build broke. One of these 2 patches (either mine
or Eugene's) is superfluous and should be dropped.
