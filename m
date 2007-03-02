Return-Path: <linux-kernel-owner+w=401wt.eu-S1422790AbXCBCbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422790AbXCBCbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422792AbXCBCbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:31:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422790AbXCBCbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:31:48 -0500
Date: Thu, 1 Mar 2007 18:31:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm release schedule?
Message-Id: <20070301183143.812b27a5.akpm@linux-foundation.org>
In-Reply-To: <48f7fe350703010634o17a35dd0p31a61cceefea27f6@mail.gmail.com>
References: <48f7fe350703010634o17a35dd0p31a61cceefea27f6@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 09:34:42 -0500
"Ryan Hope" <rmh3093@gmail.com> wrote:

> I didn't really know of a better place to ask this question, bus is
> there any rhyme or reason to when -mm kernels are released?

Not really.  I basically release them as quickly as I can, given that it
takes pretty much a full day to get a release compiling and pretending to
boot on various machines and configs.

I tend not to bother doing -mm releases during the two-week merge window
because a) I'm busy sending stuff and b) the upstream tree is changing too
fast and c) I'm busy watching people merrily merge things into mainline
which I've never seen before.

> Is there a
> -git repo that I can get work in progress for -mm?

Nope.  Because it's almost never in a compileable state.  I don't see a lot
of point in publishing a known-broken tree - all people can do is to send
me little fixes for stuff which I'll quickly fix myself anyway.

I should upload snapshots more regularly to
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ but there always
seems to be a reason not to.

