Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYHDA5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYHDA5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYHDA5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:57:32 -0400
Received: from mga10.intel.com ([192.55.52.92]:27032 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751904AbYHDA5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:57:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,302,1215414000"; 
   d="scan'208";a="367589828"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808011311360.20052@blonde.site>
References: <1217474425.25608.150.camel@ymzhang>
	 <Pine.LNX.4.64.0808011311360.20052@blonde.site>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 08:54:04 +0800
Message-Id: <1217811244.25608.175.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-01 at 13:25 +0100, Hugh Dickins wrote:
> On Thu, 31 Jul 2008, Zhang, Yanmin wrote:
> > 
> > I tried to use git bisect to locate the root cause, but git bisect
> > always went back to 2.6.26. Then, I used my mechanical bisect script...
> ....
> > BTW, sysbench+mysql(oltp readonly) has about 15% regression,
> > but git bisect looks crazy again.
> 
> I'm no git expert, but didn't see anyone else comment on this:
> you need to trust git more, it's like the Tour de France,
> occasionally venturing into other countries for a little while.
> 
> Work which got merged into Linus's 2.6.26-git for 2.6.27-rc1 may
> well have been developed on a 2.6.26-rcN base in someone else's
> tree, and so the bisection may take you back there.
> 
> I think this is getting commoner now, since Linus spoke out
> against rebasing: bisecting a net issue took me back to rc6-git
> and rc4-git, but did end up at the right commit.
Sometimes, git bisect could locate the culprit, but didn't this time.
I'm used to keep quiet when it's good but complain to make noisy when
something is wrong. :)

Thanks,
Yanmin


