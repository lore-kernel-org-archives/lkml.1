Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbYBOOMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbYBOOMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYBOOMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:12:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759292AbYBOOMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:12:42 -0500
Date: Fri, 15 Feb 2008 14:12:29 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080215141229.GB1788@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215142010.GA29552@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
> On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> > I wonder if it's worth the effort to try to implement this.

My personal view (which seems to be in the minority) is that it's a
waste of our development time *except* in the (rare?) cases similar to
the ones Andi is talking about.

But the decision has already been made for us in the block layer: 
dm is now pretty much required to support (zero-length) barriers.
Unfortunately we didn't get this finished in time for 2.6.25, but we
intend to get it done for 2.6.26:  Woe betide any callers today that
don't handle EOPNOTSUPP!

Alasdair
-- 
agk@redhat.com
