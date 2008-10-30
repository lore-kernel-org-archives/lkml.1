Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYJ3Vwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYJ3Vwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbYJ3Vwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:52:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56657 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209AbYJ3Vwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:52:33 -0400
Subject: Re: merging other repos into linux-2.6
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org>
References: <20081030054944.GA19035@kroah.com>
	 <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:52:31 -0500
Message-Id: <1225403551.3322.42.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 12:04 -0700, Linus Torvalds wrote:
> 
> On Wed, 29 Oct 2008, Greg KH wrote:
> > 
> > In working with some of the current out-of-tree drivers, some of them
> > are asking if they could keep their past development history when
> > merging the code into the main kernel tree.
> > 
> > Now normally we don't do this for new drivers, just dropping them in in
> > one big patch, or sometimes multiple patches to get it through email
> > filters.
> 
> I'd suggest you talk to Chris Mason about his btrfs import.
> 
> I'd _like_ for old history to be merged, but quite frankly, bisectability 
> is a fairly big deal, and while we often have cases where a _few_ commits 
> don't build and make bisecting hard, if you import the past development 
> history badly, you can easily end up with _hundreds_ of commits that 
> simply don't build as a kernel at all.

Is bisection really important for a new driver?  I wouldn't expect
anyone to have a config that builds a new driver when bisecting prior to
the point where the driver was merged.  Just to be safe, it would be
easy enough to have the last commit be the one that adds the driver to
Kconfig and the higher-level Makefile.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

