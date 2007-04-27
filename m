Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXD0WLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXD0WLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbXD0WLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:11:35 -0400
Received: from waste.org ([66.93.16.53]:38611 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbXD0WLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:11:33 -0400
Date: Fri, 27 Apr 2007 16:57:53 -0500
From: Matt Mackall <mpm@selenic.com>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Diego Calleja <diegocg@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070427215753.GK11166@waste.org>
References: <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr> <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de> <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl> <20070416145527.GA26863@infradead.org> <Pine.BSO.4.63.0704161734370.11088@rudy.mif.pg.gda.pl> <20070416210254.d619933c.diegocg@gmail.com> <Pine.BSO.4.63.0704162110200.11088@rudy.mif.pg.gda.pl> <20070418172519.GA5577@csclub.uwaterloo.ca> <20070427052102.GD20286@nifty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427052102.GD20286@nifty>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:21:02PM -0700, Valerie Henson wrote:
> On Wed, Apr 18, 2007 at 01:25:19PM -0400, Lennart Sorensen wrote:
> > 
> > Does it matter that google's recent report on disk failures indicated
> > that SMART never predicted anything useful as far as they could tell?
> > Certainly none of my drive failures ever had SMART make any kind of
> > indication that anything was wrong.
> 
> I saw that talk, and that's not what I got out of it.  They found that
> SMART error reports _did_ correlate with drive failure.

In fact, a certain small set of SMART indicators were a very good sign
that a drive would fail.

> However, they found that the correlation was not strong enough to make
> it economically feasible to replace disks reporting SMART failures,
> since something like 70% of disks were still working a year after the
> first failure report.  Also, they found that some disks failed without
> any SMART error reports.

Indeed, SMART registered no counts at all for most failures, so on the
whole, it can't be said that SMART can predict failures.

So: not a good idea to base your backup scheme on SMART warnings, but
not entirely useless.

-- 
Mathematics is the supreme nostalgia of our time.
