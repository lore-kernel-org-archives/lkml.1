Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbYJPW4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbYJPW4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYJPW4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:56:16 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:43713 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756257AbYJPW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:56:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALth90h5LF1j/2dsb2JhbADER4Ns
X-IronPort-AV: E=Sophos;i="4.33,427,1220193000"; 
   d="scan'208";a="232273138"
Date: Fri, 17 Oct 2008 09:56:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sean Purdy <sean-kernel@purdy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: BUG: XFS internal error xfs_trans_cancel in 2.6.27
Message-ID: <20081016225611.GC31761@disturbed>
Mail-Followup-To: Sean Purdy <sean-kernel@purdy.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	xfs@oss.sgi.com
References: <20081009113610.F13062@moloch.hellmouth.net> <20081009230227.GL9597@disturbed> <20081016151752.F30919@moloch.hellmouth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081016151752.F30919@moloch.hellmouth.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 03:17:52PM +0100, Sean Purdy wrote:
> On Fri, 10 Oct 2008, Dave Chinner said:
> > On Thu, Oct 09, 2008 at 11:36:10AM +0100, Sean Purdy wrote:
> > > Hi,
> > > 
> > > Further to the discussion (and patching) of an xfs_trans_cancel
> > > issue in June, in kernel < 2.6.26
> > > 
> > > A similar issue came up on one disk of a 4 x 750GiB machine
> > > with a 2.6.24 kernel.  So I installed 2.6.27-6 and gave it another try.
> > > But I'm still seeing the same problem.  Remounting the drive each time
> > > is fine, and xfs_check shows no errors.
> > 
> > 2.6.27-6? You mean 2.6.27-rc6?
> 
> I meant rc9 as it happens, but never mind.
>  
> > Anyway, you need to try this patch:
> > 
> > http://oss.sgi.com/archives/xfs/2008-10/msg00105.html
> > 
> > which I posted a few days ago that fixes the latest reproducable
> > case of this shutdown that I know of.
> 
> This patch worked fine, thanks very much!

Great. It's good to know that mutliple people إve been hitting
this specific problem.

> Can we get it into
> some stable version of 2.6.27?  Maybe I can put in a bug request
> for the next Ubuntu kernel.

We haven't pushed it upstream for .28-rc1 yet as it is still being
QA'd. Once it is pushed we can consider it for .27-stable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
