Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbXCZQLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbXCZQLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 12:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXCZQLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 12:11:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXCZQLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 12:11:54 -0400
Date: Mon, 26 Mar 2007 17:11:46 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dm-crypt@saout.de
Subject: Re: race condition in dm-crypt?
Message-ID: <20070326161146.GA3535@agk.fab.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, dm-crypt@saout.de
References: <20070323170535.GA3057@hejre.minidns.net> <20070323174214.GA14179@tatooine.rebelbase.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323174214.GA14179@tatooine.rebelbase.local>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 06:42:14PM +0100, markus reichelt wrote:
> * "Jan C. Nordholz" <jckn@gmx.net> wrote:
> > I'm seeing this for quite a while now (since 2.6.16 at least), but
> > without any obvious indicator to what might be causing it... where
> > should I continue debugging this?
> I bet folks at dm-crypt@saout.de would love to hear about this.
 
As mentioned in another thread, please try these patches if they aren't already
in your kernel:

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.19/dm-io-fix-bi_max_vecs.patch                                                                                       

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-merge-max_hw_sector.patch            

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-disable-barriers.patch

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-call-to-clone_init.patch
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-remove-first_clone.patch
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-use-smaller-bvecs-in-clones.patch

Alasdair
-- 
agk@redhat.com
