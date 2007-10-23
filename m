Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXJWHOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXJWHOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJWHN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:13:56 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3125 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbXJWHNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:13:55 -0400
Date: Tue, 23 Oct 2007 09:12:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Joachim Fenkes <fenkes@de.ibm.com>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: IB/ehca: Fix sg_page() fallout
Message-ID: <20071023071230.GD25962@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <20071023040948.GA19699@lixom.net> <20071023043148.GA20904@lixom.net> <20071023050512.GK16425@kernel.dk> <20071023055439.GA22426@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023055439.GA22426@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Olof Johansson wrote:
> 
> More fallout from sg_page changes:
> 
> drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_set_pagebuf_user1':
> drivers/infiniband/hw/ehca/ehca_mrmw.c:1779: error: 'struct scatterlist' has no member named 'page'
> drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_check_kpages_per_ate':
> drivers/infiniband/hw/ehca/ehca_mrmw.c:1835: error: 'struct scatterlist' has no member named 'page'
> drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_set_pagebuf_user2':
> drivers/infiniband/hw/ehca/ehca_mrmw.c:1870: error: 'struct scatterlist' has no member named 'page'
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> 
> ---
> 
> On Tue, Oct 23, 2007 at 07:05:12AM +0200, Jens Axboe wrote:
> > On Mon, Oct 22 2007, Olof Johansson wrote:
> > > More fallout from sg_page changes, found with powerpc allyesconfig:
> > > 
> > > drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_set_pagebuf_user1':
> > > drivers/infiniband/hw/ehca/ehca_mrmw.c:1779: error: 'struct scatterlist' has no member named 'page'
> > > drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_check_kpages_per_ate':
> > > drivers/infiniband/hw/ehca/ehca_mrmw.c:1835: error: 'struct scatterlist' has no member named 'page'
> > > drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_set_pagebuf_user2':
> > > drivers/infiniband/hw/ehca/ehca_mrmw.c:1870: error: 'struct scatterlist' has no member named 'page'
> > 
> > Thanks a lot Olof, applied both fixups!
> 
> I messed up the second fix. :( please replace with this.

No problem, applied.

-- 
Jens Axboe

