Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0CHJQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:16:33 -0500
Received: from amnesiac.heapspace.net ([80.87.131.51]:4332 "EHLO
	amnesiac.heapspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0CHJQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:16:30 -0500
X-Greylist: delayed 1163 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 04:16:30 EST
Date: Mon, 8 Mar 2010 08:57:04 +0000
From: Daniel Stone <daniel@fooishbar.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@linux.ie>,
       "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, dri-devel@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Making Xorg easier to test (was Re: [git pull] drm request 3)
Message-ID: <20100308085704.GB52175@amnesiac.heapspace.net>
References: <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com> <20100305074407.GC19703@elte.hu> <20100305100030.GA4970@Pilar.aei.mpg.de> <alpine.LFD.2.00.1003050726520.3788@localhost.localdomain> <20100305161143.GG2505@tempa> <alpine.LFD.2.00.1003050819490.3788@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.2.00.1003050819490.3788@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 08:30:38AM -0800, Linus Torvalds wrote:
> On Fri, 5 Mar 2010, Daniel Stone wrote:
> > FWIW, Option "ModulePath" in xorg.conf lets you more or less do this;
> > the usual approach is to install your new server + drivers into a
> > separate prefix.
> 
> The thing is, Xorg has - and I think for _very_ good reasons - deprecated 
> using xorg.conf at all. So most people don't even have one (I certainly 
> don't), and wouldn't know how to create one in the first place.

Most people don't know how to bisect the kernel, either. :)

xorg.conf hasn't at all been deprecated, beyond autoconf and
xorg.conf.d.  The goal was to ensure that no-one needed an xorg.conf _by
default_, which I can quite safely say we've since achieved, but
xorg.conf(.d) remains as the way to tell the server your non-default
requirements.

Anyway, badly OT here, so.

Cheers,
Daniel
