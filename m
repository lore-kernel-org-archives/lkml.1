Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZFYP2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZFYP2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbZFYP1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:27:43 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55429 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbZFYP1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:27:41 -0400
Date: Thu, 25 Jun 2009 08:27:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, davem@davemloft.net, dada1@cosmosbay.com,
       zbr@ioremap.net, jeff.chua.linux@gmail.com, paulus@samba.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH -tip 0/3] expedited "big hammer" RCU grace periods
Message-ID: <20090625152736.GC6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090624164535.GA13334@linux.vnet.ibm.com> <20090624180303.GE7576@elte.hu> <20090624184423.GK6779@linux.vnet.ibm.com> <20090625095953.GC29980@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625095953.GC29980@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 11:59:53AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Jun 24, 2009 at 08:03:03PM +0200, Ingo Molnar wrote:
> > > 
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > >  include/linux/rcuclassic.h    |   15 ++-
> > > 
> > > heh, we dont have this file anymore ... as of today, right? :)
> > 
> > Ah, I was assuming that expedited RCU would happen before removal 
> > of Classic RCU.
> 
> Our general preference is to zap code.

Actually worked out nicely in this case -- the fact that Classic RCU
is no longer in -tip meant that I could dump 25% of my test cases for
expedited RCU.  ;-)

I will be posting the updated patch shortly.

> /me stares at:
> 
>   $ git diff --stat -M v2.6.30..v2.6.31-rc1 | tail -1
>   7743 files changed, 782278 insertions(+), 403162 deletions(-)
> 
> /me corrects himself:
> 
> Okay, so the zapping of code is the divine guiding principle we've 
> been following for 15 years. Ending up with a kernel that is 11 
> million lines of code is a small imperfection of mankind and is to 
> be fixed.

;-)  ;-)  ;-)

I guess that if 11 million lines of code is a small imperfection of
mankind, we can only be thankful that we are not tasked with dealing
with the large imperfections.  ;-)

							Thanx, Paul
