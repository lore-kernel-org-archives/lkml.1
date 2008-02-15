Return-Path: <linux-kernel-owner+w=401wt.eu-S934735AbYBOO7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735AbYBOO7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbYBOO6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:58:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60346 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559AbYBOO6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:58:54 -0500
Date: Fri, 15 Feb 2008 16:34:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: device-mapper development <dm-devel@redhat.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080215153439.GB30504@one.firstfloor.org>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215141229.GB1788@agk.fab.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 02:12:29PM +0000, Alasdair G Kergon wrote:
> On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
> > On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> > > I wonder if it's worth the effort to try to implement this.
> 
> My personal view (which seems to be in the minority) is that it's a
> waste of our development time *except* in the (rare?) cases similar to

At least for my machines it is the standard case; it is not rare.

And don't RH distributions install with LVM by default these days?
For those it should be the standard case too on all systems with
only a single disk.

The other relatively simple case I plan to look into (in fact
I already wrote something, but it's not postable yet) is dm-crypt
on single device. But it's a little more complicated than the
simple dm-linear case.

-Andi 
