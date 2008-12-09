Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYLIQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYLIQcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYLIQcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:32:05 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54829 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYLIQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:32:04 -0500
Date: Tue, 9 Dec 2008 10:16:20 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
Message-ID: <20081209161620.GC9487@us.ibm.com>
References: <20081208215221.GA3954@us.ibm.com> <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org> <20081209024543.GA11538@elte.hu> <alpine.LRH.1.10.0812092005100.10841@tundra.namei.org> <20081209100817.GA11886@elte.hu> <alpine.LRH.1.10.0812092114140.11867@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0812092114140.11867@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Tue, 9 Dec 2008, Ingo Molnar wrote:
> 
> > > They're already published in my tree.  Do you want me to revert them?
> > 
> > I've also got it published :-/ If it's at the tail of your commits, can 
> > you reset it?
> 
> There have been commits since, and people are using the tree in any case.

Yikes.  Maybe it's best (henceforth) to keep user namespaces patches in
their own tree toward the end of linux-next?  There certainly are
security implications with all of them, but other things (filesystem,
sched) will be impacted as well...

Sorry.

-serge
