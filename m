Return-Path: <linux-kernel-owner+w=401wt.eu-S936385AbXGMSnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936385AbXGMSnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbXGMSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:43:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756918AbXGMSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:43:04 -0400
Date: Fri, 13 Jul 2007 11:42:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       "andros @ citi . umich . edu" <andros@citi.umich.edu>,
       "J . Bruce Fields" <bfields@puzzle.fieldses.org>,
       Usha Ketineni <ketineni@us.ibm.com>,
       Usha Ketineni <uketinen@us.ibm.com>
Subject: Re: [PATCH 000 of 20] knfsd: Support 'secinfo' exports with related
 cleanups
Message-Id: <20070713114228.3c171a90.akpm@linux-foundation.org>
In-Reply-To: <20070713181025.GM12582@fieldses.org>
References: <20070710121949.12548.patches@notabene>
	<20070713003310.2df90a38.akpm@linux-foundation.org>
	<20070713181025.GM12582@fieldses.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 14:10:25 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Fri, Jul 13, 2007 at 12:33:10AM -0700, Andrew Morton wrote:
> > On Tue, 10 Jul 2007 12:22:37 +1000 NeilBrown <neilb@suse.de> wrote:
> > 
> > > With this patchset it becomes possible to list a number of different
> > > security flavours that maybe used to access an exported filesystem,
> > > and to attach different export options (e.g. readonly, rootsquash) to
> > > different flavours.
> > > Also, NFSv4 can report which flavours are available on a particular export.
> > 
> > Please consider feeding knfsd patches through checkpatch in the future.  It
> > did find several glitches in these patches which you might have chosen
> > to address.
> 
> OK.  I guess I'll wait till the next -mm is out, take a look, and
> address your comments then.

I probably won't get another -mm out until after the 2.6.23 merge window
closes.  One reason for this is all the extra time which I need to devote
to code-review, hint.

But I don't think there was anything which I identified in this nfsd batch
which needs attention prior to a 2.6.23-rc1 merge.  The checkpatch stuff is
more a "please do this next time" thing.
