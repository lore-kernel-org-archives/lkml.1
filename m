Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYB0T4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYB0T4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbYB0Tzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:55:46 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52661 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758767AbYB0Tzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:55:44 -0500
Date: Wed, 27 Feb 2008 14:55:25 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 27
Message-ID: <20080227195525.GC8840@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20080227170300.25c50fe3.sfr@canb.auug.org.au> <20080226230059.58cf3cfa.akpm@linux-foundation.org> <20080228010626.fd4e00d2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228010626.fd4e00d2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 01:06:26AM +1100, Stephen Rothwell wrote:
> On Tue, 26 Feb 2008 23:00:59 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > So who's missing now?

> > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/

Hi Stephen,

please add:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git  next

This contains a subset of the patches in the ext4 patch set which we
are explicitly planning on pushing to Linus at the next merge window.

It actually probably wouldn't hurt to pull the entire quilt series
into linux-next, since we don't export any interfaces that are used by
other linux trees, and that would give us better heads up for
conflicts in patches still in development conflicting with upcoming
core changes.  But it conflicts with the initial premise of
linux-next, so that's why I set up the next branch of the above git
tree.

Regards,

						- Ted
