Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbXCHQUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbXCHQUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXCHQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:20:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbXCHQUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:20:33 -0500
Subject: Re: [PATCH] Add xfrm policy change auditing to pfkey_spdget
From: Eric Paris <eparis@parisplace.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jmorris@namei.org,
       vyekkirala@trustedcs.com, cxzhang@watson.ibm.com, sds@tycho.nsa.gov
In-Reply-To: <20070307.160740.77057241.davem@davemloft.net>
References: <1172861484.31047.26.camel@localhost.localdomain>
	 <20070307.154316.68038380.davem@davemloft.net>
	 <20070307.160740.77057241.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 11:20:15 -0500
Message-Id: <1173370815.31047.134.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 16:07 -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 07 Mar 2007 15:43:16 -0800 (PST)
> 
> > From: Eric Paris <eparis@parisplace.org>
> > Date: Fri, 02 Mar 2007 13:51:24 -0500
> > 
> > > pfkey_spdget neither had an LSM security hook nor auditing for the
> > > removal of xfrm_policy structs.  The security hook was added when it was
> > > moved into xfrm_policy_byid instead of the callers to that function by
> > > my earlier patch and this patch adds the auditing hooks as well.
> > > 
> > > Signed-off-by: Eric Paris <eparis@redhat.com>
> > 
> > Applied.
> 
> This patch was missing an openning brace on the "if (delete)" line.
> Eric you don't post patches without at least compile testing
> them now do you? :-)
> 
> I fixed this up, but I will just kick it back to you next time,
> and I will likely growl very loudly in your general direction
> too. ;)

I lose at using git.  Sorry.  I'll be more careful to check that all of
my changes on the current branch are committed before I run my git diff.
Or maybe someone will convince me to use git in an all new better way.
I created a branch that has your tree and then created a new branch off
of that for my changes.  I checked out my branch made my patch and
commited.  I then tried to compile failed and fixed it up.  I then
compiled, booted, and tested.  When I thought it was working I did a

git diff miller..my-branch-with-pfkey_spdget

which didn't have my fix up because i didn't commit it to my local
branch.  Is there a better way to get a diff between my miller tree and
'everything in the branch I have checked out even if it is not
committed'?

Sorry, even if there are no ideas I'll be more careful.

-Eric

