Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYJPOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYJPOX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYJPOXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:23:20 -0400
Received: from moloch.purdy.org ([192.207.141.11]:4214 "EHLO
	moloch.hellmouth.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYJPOXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:23:20 -0400
Date: Thu, 16 Oct 2008 15:17:52 +0100
From: Sean Purdy <sean-kernel@purdy.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: david@fromorbit.com
Subject: Re: BUG: XFS internal error xfs_trans_cancel in 2.6.27
Message-ID: <20081016151752.F30919@moloch.hellmouth.net>
References: <20081009113610.F13062@moloch.hellmouth.net> <20081009230227.GL9597@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20081009230227.GL9597@disturbed>; from david@fromorbit.com on Fri, Oct 10, 2008 at 10:02:27AM +1100
X-Comments: Public PGP key available on request
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Dave Chinner said:
> On Thu, Oct 09, 2008 at 11:36:10AM +0100, Sean Purdy wrote:
> > Hi,
> > 
> > Further to the discussion (and patching) of an xfs_trans_cancel
> > issue in June, in kernel < 2.6.26
> > 
> > A similar issue came up on one disk of a 4 x 750GiB machine
> > with a 2.6.24 kernel.  So I installed 2.6.27-6 and gave it another try.
> > But I'm still seeing the same problem.  Remounting the drive each time
> > is fine, and xfs_check shows no errors.
> 
> 2.6.27-6? You mean 2.6.27-rc6?

I meant rc9 as it happens, but never mind.
 
> Anyway, you need to try this patch:
> 
> http://oss.sgi.com/archives/xfs/2008-10/msg00105.html
> 
> which I posted a few days ago that fixes the latest reproducable
> case of this shutdown that I know of.

This patch worked fine, thanks very much!  Can we get it into
some stable version of 2.6.27?  Maybe I can put in a bug request
for the next Ubuntu kernel.


Sean
