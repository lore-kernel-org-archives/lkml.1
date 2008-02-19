Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbYBSLNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbYBSLNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbYBSLMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:12:46 -0500
Received: from relay1.sgi.com ([192.48.171.29]:54730 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760602AbYBSLMp (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:12:45 -0500
Date: Tue, 19 Feb 2008 22:12:22 +1100
From: David Chinner <dgc@sgi.com>
To: Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080219111222.GE155407@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080219023900.GB4066@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219023900.GB4066@agk.fab.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 02:39:00AM +0000, Alasdair G Kergon wrote:
> > For example, how safe
> > xfs is if barriers are not supported or turned off?  
> 
> The last time we tried xfs with dm it didn't seem to notice -EOPNOTSUPP
> everywhere it should => recovery may find corruption.

Bug reports, please. What we don't know about, we can't fix.

As of this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0bfefc46dc028df60120acdb92062169c9328769

XFS should be handling all cases of -EOPNOTSUPP for barrier
I/Os. If you are still having problems, please let us know.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
