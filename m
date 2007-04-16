Return-Path: <linux-kernel-owner+w=401wt.eu-S1030922AbXDPTwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030922AbXDPTwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030923AbXDPTwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:52:40 -0400
Received: from lazybastard.de ([212.112.238.170]:55245 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030922AbXDPTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:52:39 -0400
Date: Mon, 16 Apr 2007 21:46:45 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070416194644.GA27843@lazybastard.org>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr> <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de> <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl> <20070416145527.GA26863@infradead.org> <Pine.BSO.4.63.0704161734370.11088@rudy.mif.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSO.4.63.0704161734370.11088@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 April 2007 17:46:50 +0200, Tomasz Kłoczko wrote:
> On Mon, 16 Apr 2007, Christoph Hellwig wrote:
> 
> >Numbers, please.  So far in all interesting benchmarks it actually
> >was slower.  But when they're faster than XFS somewhere I'd defintly
> >be interesting in looking at why this is true and if possible and
> >important enough fix it.

Christoph, could you show some numbers as well?  While I usually trust
your opinion, I have yet to see any substantial argument against ZFS
from your side.

> http://cmynhier.blogspot.com/2006/05/zfs-io-reordering-benchmark.html

http://blogs.sun.com/bill/#zfs_vs_the_benchmark

If you read closely you may notice that ZFS had relatively little to do
with read performance under heavy write load.  ZFS simply has "some fancy
I/O scheduling code" that in particular deals with deadlines.  The Linux
equivalent appears to be CONFIG_IOSCHED_DEADLINE.  But the quoted
benchmark does not mention which scheduler was used for Linux.

So unless the benchmark is redone and properly documented, its numbers
are fairly worthless.  Bummer.

> http://cmynhier.blogspot.com/2006/05/zfs-benchmarking.html

"The company I work for would probably balk if I put that script here"

No publically available benchmark.  So even if a third party wanted to,
it couldn't recreate the benchmark.  Again, fairly worthless.


So by my count, neither side has showed any worthwile numbers.  Whether
ZFS performance is better or worse is anyone's guess.

Jörn

-- 
Simplicity is prerequisite for reliability.
-- Edsger W. Dijkstra
