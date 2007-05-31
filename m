Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbXEaM0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbXEaM0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXEaM0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:26:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760958AbXEaM0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:26:45 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 31 May 2007 22:26:22 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18014.48878.442628.260297@notabene.brown>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] sendfile removal
In-Reply-To: message from Jens Axboe on Thursday May 31
References: <20070531103316.GO32105@kernel.dk>
	<20070531105543.GA25676@infradead.org>
	<20070531110550.GR32105@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 31, jens.axboe@oracle.com wrote:
> On Thu, May 31 2007, Christoph Hellwig wrote:
> > On Thu, May 31, 2007 at 12:33:16PM +0200, Jens Axboe wrote:
> > > - nfds: The ->rq_sendfile_ok optimization is gone for now. I can't
> > >   determine the value of it, but I'm assuming it's there for a reason.
> > >   Any chance this can be converted to splice, or use something else than
> > >   ->sendfile()? CC'ed Neil.
> > 
> > sendfile useage in nfsd avoids a data copy and allows to use checksum
> > offloading.  it's quite important for nfs server workloads.
> 
> OK, I hope Neil can provide some input on how to convert it. Of course
> I'm just fishing for Neil to actually do that work :-)

Well, seeing you did that zero-length-barrier thing for me, how can I
complain :-)

I'll have a look in the morning.

NeilBrown
