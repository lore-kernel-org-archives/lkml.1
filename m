Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbYHAM0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbYHAM0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbYHAM0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:26:03 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:40366 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYHAM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:26:01 -0400
Date: Fri, 1 Aug 2008 13:25:57 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: VolanoMark regression with 2.6.27-rc1
In-Reply-To: <1217474425.25608.150.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0808011311360.20052@blonde.site>
References: <1217474425.25608.150.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Zhang, Yanmin wrote:
> 
> I tried to use git bisect to locate the root cause, but git bisect
> always went back to 2.6.26. Then, I used my mechanical bisect script...
....
> BTW, sysbench+mysql(oltp readonly) has about 15% regression,
> but git bisect looks crazy again.

I'm no git expert, but didn't see anyone else comment on this:
you need to trust git more, it's like the Tour de France,
occasionally venturing into other countries for a little while.

Work which got merged into Linus's 2.6.26-git for 2.6.27-rc1 may
well have been developed on a 2.6.26-rcN base in someone else's
tree, and so the bisection may take you back there.

I think this is getting commoner now, since Linus spoke out
against rebasing: bisecting a net issue took me back to rc6-git
and rc4-git, but did end up at the right commit.

It can be nuisance if you don't notice at "make install" time,
and reboot another kernel than the one you just built to test.

Hugh
