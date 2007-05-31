Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXEaAXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXEaAXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXEaAXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:23:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:40675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbXEaAXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:23:21 -0400
From: Neil Brown <neilb@suse.de>
To: Phillip Susi <psusi@cfl.rr.com>
Date: Thu, 31 May 2007 10:22:58 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18014.5474.664638.694584@notabene.brown>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
In-Reply-To: message from Phillip Susi on Tuesday May 29
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<465C8625.1010001@cfl.rr.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 29, psusi@cfl.rr.com wrote:
> Neil Brown wrote:
> >  md/dm modules could keep count of requests as has been suggested
> >  (though that would be a fairly big change for raid0 as it currently
> >  doesn't know when a request completes - bi_endio goes directly to the
> >  filesystem). 
> 
> Are you sure?  I believe that dm handles bi_endio because it waits for 
> all in progress bio to complete before switching tables.

I was taking about md/raid0, not dm-stripe.
md/raid0 (and md/linear) currently never know that a request has
completed.

NeilBrown
