Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZFPP7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZFPP7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZFPP7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:59:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZFPP7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:59:07 -0400
Date: Tue, 16 Jun 2009 17:59:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090616155907.GA1552@wotan.suse.de>
References: <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop> <20090615112355.GB6012@wotan.suse.de> <Pine.LNX.4.64.0906151329310.24256@sister.anvils> <20090616045704.GC28596@wotan.suse.de> <1245130087.12400.82.camel@pasglop> <20090616053609.GB2924@wotan.suse.de> <alpine.DEB.1.10.0906161110481.26093@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906161110481.26093@gentwo.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:12:58AM -0400, Christoph Lameter wrote:
> On Tue, 16 Jun 2009, Nick Piggin wrote:
> 
> > There aren't too many significant code simplifications AFAIKS.
> 
> The code simplification comes from the ability to run the same code during
> boot that is also running when the full system is operational. I thought
> the intend of this whole exercise was to avoid special casing as much as
> possible and reduce the amount of code specifically duplicated for boot
> situations?

That is one of the advantages, yes. As far as I can see though,
there isn't like *huge* amounts of things you can simplify. And
if it is just a matter of removing a few branches from a few
cold paths, then it isn't necessarily a good reason to push
branches into the slab and page allocators.

I'm not saying we definitely should go one way or the other, I
would just like to wait and see.

