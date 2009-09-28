Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZI1Iug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZI1Iug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZI1Iug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:50:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44136 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZI1Iuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:50:35 -0400
Date: Mon, 28 Sep 2009 10:50:37 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH] linux-next: 20090926 - drop autoconf.h from
	DRBD driver
Message-ID: <20090928085037.GA8048@barkeeper1-xen.linbit>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg KH <greg@kroah.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
	drbd-dev@lists.linbit.com
References: <20090926152800.a6568e53.sfr@canb.auug.org.au> <20090926173143.GA5041@linux.vnet.ibm.com> <20090926200839.GA5220@merkur.ravnborg.org> <20090927125331.5367db08.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090927125331.5367db08.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 12:53:31PM +1000, Stephen Rothwell wrote:
> Hi Greg, Philipp,
> 
> On Sat, 26 Sep 2009 22:08:39 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > On Sat, Sep 26, 2009 at 11:01:43PM +0530, Kamalesh Babulal wrote:
> > > 
> > > 	next-20090926 allyesconfig build breaks on powerpc,
> > > 
> > > drivers/block/drbd/drbd_proc.c:26:28: error: linux/autoconf.h: No such file or directory
> > > make[3]: *** [drivers/block/drbd/drbd_proc.o] Error 1
> > > 
> > > dropping autoconf.h from drbd_proc.c helps. The cleanup patch drops the
> > > unneeded include autoconf.h.
> > > 
> > > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > 
> > I only checked upstream - so this is no big suprise.
> > As there is no need to explicitly include autoconf.h this
> > change should be included by the drdb folks even if the
> > stuff I have does not hit upstream.
> 
> Maybe we should let them know (cc'd).


Thanks ;)
owed to our out-of-tree "backwards" compatibility for all 2.6 kernels
back to 2.6.5 (I think...).

includes have been dropped.

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
