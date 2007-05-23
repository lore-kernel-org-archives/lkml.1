Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbXEWDkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbXEWDkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 23:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbXEWDkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 23:40:35 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43170 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbXEWDke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 23:40:34 -0400
Date: Tue, 22 May 2007 20:36:51 -0700
From: Greg KH <greg@kroah.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, Andi Kleen <ak@suse.de>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [stable] [patch 00/69] -stable review
Message-ID: <20070523033651.GC26416@kroah.com>
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org> <20070521222004.GT6291@stusta.de> <46521BFD.7040703@redhat.com> <8E8F647D7835334B985D069AE964A4F7028FE807@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E8F647D7835334B985D069AE964A4F7028FE807@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 09:28:34PM -0400, Fortier,Vincent [Montreal] wrote:
> > -----Message d'origine-----
> > De : linux-kernel-owner@vger.kernel.org 
> > [mailto:linux-kernel-owner@vger.kernel.org] De la part de Chuck Ebbert
> > Envoy? : 21 mai 2007 18:24
> > 
> > Adrian Bunk wrote:
> > > On Mon, May 21, 2007 at 12:31:48PM -0700, Andrew Morton wrote:
> > >> On Mon, 21 May 2007 12:16:12 -0700
> > >> Chris Wright <chrisw@sous-sol.org> wrote:
> > >>
> > >>> This is the start of the stable review cycle for the 2.6.21.2 release.
> > >> Gee a lot of these are fixing recently-added regressions :( ...
> > > 
> > > If only it would fix all of them...
> > > 
> > > Michal's list [1] currently contains 51 different regressions in
> > > 2.6.21 compared to 2.6.20 (12 of them were already reported before
> > > 2.6.21 was released).
> > 
> > Yeah, 2.6.21 seems awfully buggy, and patches to fix many of 
> > the bugs haven't appeared.
> > 
> > Another 2.6.20 update seems to be in order...
> 
> Hi,
> 
> If there is a new stable 2.6.20 / 2.6.21, would it be possible that they both contain also this patch to keep the same behaviour between 2.6.20 -> 2.6.22 kernels regarding paravirt_ops GPL export?
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=21564fd2a3deb48200b595332f9ed4c9f311f2a7

Why?  Is there an in-kernel use for that export?

thanks,

greg k-h
