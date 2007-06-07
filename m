Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXFGLH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXFGLH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbXFGLHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:07:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34475 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753644AbXFGLHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:07:39 -0400
Date: Thu, 7 Jun 2007 21:07:10 +1000
From: David Chinner <dgc@sgi.com>
To: David Greaves <david@dgreaves.com>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Message-ID: <20070607110708.GS86004887@sgi.com>
References: <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667DE2D.6050903@dgreaves.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:30:05AM +0100, David Greaves wrote:
> Tejun Heo wrote:
> >Hello,
> >
> >David Greaves wrote:
> >>Just to be clear. This problem is where my system won't resume after s2d
> >>unless I umount my xfs over raid6 filesystem.
> >
> >This is really weird.  I don't see how xfs mount can affect this at all.
> Indeed.
> It does :)

Ok, so lets determine if it really is XFS.  Does the lockup happen with a
different filesystem on the md device? Or if you can't test that, does
any other XFS filesystem you have show the same problem?

If it is xfs that is causing the problem, what happens if you
remount read-only instead of unmounting before shutting down?
What about freezing the filesystem?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
