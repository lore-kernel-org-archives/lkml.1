Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbXD0FVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbXD0FVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXD0FVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:21:08 -0400
Received: from mga06.intel.com ([134.134.136.21]:42156 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755353AbXD0FVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:21:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,454,1170662400"; 
   d="scan'208";a="234882424"
Date: Thu, 26 Apr 2007 22:21:02 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Diego Calleja <diegocg@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070427052102.GD20286@nifty>
References: <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr> <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de> <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl> <20070416145527.GA26863@infradead.org> <Pine.BSO.4.63.0704161734370.11088@rudy.mif.pg.gda.pl> <20070416210254.d619933c.diegocg@gmail.com> <Pine.BSO.4.63.0704162110200.11088@rudy.mif.pg.gda.pl> <20070418172519.GA5577@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418172519.GA5577@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 01:25:19PM -0400, Lennart Sorensen wrote:
> 
> Does it matter that google's recent report on disk failures indicated
> that SMART never predicted anything useful as far as they could tell?
> Certainly none of my drive failures ever had SMART make any kind of
> indication that anything was wrong.

I saw that talk, and that's not what I got out of it.  They found that
SMART error reports _did_ correlate with drive failure.  See page 8
of:

http://www.usenix.org/events/fast07/tech/full_papers/pinheiro/pinheiro.pdf

(If you're not a USENIX member, you may be able to find a free
download copy elsewhere.)

However, they found that the correlation was not strong enough to make
it economically feasible to replace disks reporting SMART failures,
since something like 70% of disks were still working a year after the
first failure report.  Also, they found that some disks failed without
any SMART error reports.

Now, Google keeps multiple copies (3 in GoogleFS, last I heard) of
data, so for them, "economically feasible" means something different
than for my personal laptop hard drive.  I have twice had my laptop
hard drive start spitting SMART errors and then die within a week.  It
is economically quite sensible for me to replace my laptop drive once
it has an error, since I don't carry around 3 laptops everywhere I go.

-VAL
