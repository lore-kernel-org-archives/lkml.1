Return-Path: <linux-kernel-owner+w=401wt.eu-S935464AbYCFSRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935464AbYCFSRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYCFSRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:17:46 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:28348 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYCFSRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:17:44 -0500
Subject: Re: [BUG] 2.6.25-rc4 hang/softlockups after freeing hugepages
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20080306175311.GA14567@us.ibm.com>
References: <1204824183.5294.62.camel@localhost>
	 <20080306175311.GA14567@us.ibm.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 06 Mar 2008 13:17:52 -0500
Message-Id: <1204827473.5294.77.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 09:53 -0800, Nishanth Aravamudan wrote:
> On 06.03.2008 [12:23:03 -0500], Lee Schermerhorn wrote:
> > Test platform:  HP Proliant DL585 server - 4 socket, dual core AMD with
> > 32GB memory.
> > 
> > I first saw this on 25-rc2-mm1 with Mel's zonelist patches, while
> > investigating the interaction of hugepages and cpusets.  Thinking that
> > it might be caused by the zonelist patches, I went back to 25-rc2-mm1
> > w/o the patches and saw the same thing.  It sometimes takes a while for
> > the softlockups to start appearing, and I wanted to find a fairly
> > minimal duplicator.  Meanwhile 25-rc3 and rc4 have come out, so I tried
> > the latest upstream kernel and see the same thing.
> 
> So, does 2.6.25-rc2 show the problem? Or was it something introduced in
> that -mm which has since gone upstream?
> 

I don't recall that I went back that far.  I'll try Ingo's patch [later,
after an obligatory meeting...] and let you know.

<snip>
> > I took a look at the recent hugetlb patches from Adam and Nish, but none
> > seemed to address this symptom.  I don't think I'm dealing with surplus
> > pages here.
> 
> If /proc/sys/vm/nr_overcommit_hugepages = 0, then no, you're not.

I didn't set that, so it should have been zero.

Lee


