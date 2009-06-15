Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZFOJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZFOJit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZFOJim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:38:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZFOJil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:38:41 -0400
Date: Mon, 15 Jun 2009 11:38:42 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615093842.GB1314@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906121317140.23840@gentwo.org> <1244843163.23936.2.camel@pasglop> <20090615064653.GB18390@wotan.suse.de> <1245057052.23207.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245057052.23207.8.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:10:52PM +0300, Pekka Enberg wrote:
> On Mon, 2009-06-15 at 08:46 +0200, Nick Piggin wrote:
> > On Sat, Jun 13, 2009 at 07:46:03AM +1000, Benjamin Herrenschmidt wrote:
> > > 
> > > > Adds code to hot code path.
> > > 
> > > A single mask which should be mostly in the noise...
> > 
> > Cacheline load. Yes it will be in the noise. Like all other slowdowns
> > that get merged ;)
> 
> Yes, agreed. Did you see the patch I suggested to move all of this
> outside of fastpaths for production configs?

Yes I did see it go by. I'm always in favour of cutting
even a few cycles and definitely a cacheline from mm fastpaths.

