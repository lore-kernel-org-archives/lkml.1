Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZIRGy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZIRGy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZIRGyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:54:47 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:57038 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbZIRGyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:54:46 -0400
X-Trace: 259489334/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.73.110/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.73.110
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABvMskpPRUlu/2dsb2JhbACBUtJmhBwFgVg
X-IronPort-AV: E=Sophos;i="4.44,408,1249254000"; 
   d="scan'208";a="259489334"
Date: Fri, 18 Sep 2009 07:53:58 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
Subject: Re: aim7 scalability issue on 4 socket machine
In-Reply-To: <20090917195909.3a00ef83.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
References: <1253179879.2606.37.camel@ymzhang> <1253180411.8497.1.camel@twins>
 <Pine.LNX.4.64.0909171122180.25864@sister.anvils> <1253239339.2606.40.camel@ymzhang>
 <20090917195909.3a00ef83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Andrew Morton wrote:
> On Fri, 18 Sep 2009 10:02:19 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> > > and let us know if that works as well for you - thanks.
> > I tested Lee's patch and it does fix the issue.

Thanks for checking and reporting back, Yanmin.

> 
> Do we think we should cook up something for -stable?

Gosh, I laughed at Lee (sorry!) for suggesting it for -stable:
is stable really for getting a better number out of a benchmark?

I'd have thought the next release is the right place for that; but
I've no problem if you guys and the stable guys agree it's appropriate.

> 
> Either this is a regression or the workload is particularly obscure. 

I've not cross-checked descriptions, but assume Lee was actually
testing on exactly the same kind of upcoming Nehalem as Yanmin, and
that machine happens to have characteristics which show up badly here.

> 
> aim7 is sufficiently non-obscure to make me wonder what's happened here?

Not a regression, just the onward march of new hardware, I think.
Could easily be other such things in other places with other tests.

Hugh
