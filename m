Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbZFOLYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbZFOLYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZFOLXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:23:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174AbZFOLXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:23:53 -0400
Date: Mon, 15 Jun 2009 13:23:55 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615112355.GB6012@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245062727.12400.23.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 08:45:27PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-15 at 12:27 +0200, Nick Piggin wrote:
> > Init code doesn't deserve to be more lazy than anybody else, and
> > part of the reason why such a core piece of code is so crufty
> > is exactly because people have been lazy there.
> 
> I think the main problem isn't necessarily init code per se, but the
> pile of -common- code that can be called both at init time and later.

Just seems bogus argument. Everwhere else that does this (ie.
allocations that are called from multiple allocation contexts)
passes correct gfp flags down.

