Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYIAKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYIAKQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 06:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYIAKQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 06:16:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51852 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYIAKQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 06:16:04 -0400
Date: Mon, 1 Sep 2008 12:15:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, lvm-devel@redhat.com
Subject: Re: [dm-devel] Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt() related?
Message-ID: <20080901101543.GL20055@kernel.dk>
References: <4963.1220240176@turing-police.cc.vt.edu> <48BBA0B0.5070309@kernel.org> <7045.1220260558@turing-police.cc.vt.edu> <20080901095651.GI15123@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901095651.GI15123@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01 2008, Alasdair G Kergon wrote:
> On Mon, Sep 01, 2008 at 05:15:58AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:
> > > Yeah, I made a mistake converting two of them and devt lookup fails when
> > > the disk is zero sized.  Bartlomiej debugged the problem and posted a
> > > patch and I followed up with an updated patch.  It should be fine in the
> > > next round.
> > >   http://article.gmane.org/gmane.linux.kernel.next/2663
> > >   http://article.gmane.org/gmane.linux.kernel.next/2676
> > > If you're seeing other problems, please let me know.
> > Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
> > does find the LVM volumes and come up.  Thanks for the clue.. :)
> 
> I expect we'll need some patches to userspace lvm2 to support these extended
> device numbers properly too...
> 
> Alasdair (back from holiday)

They'll be defaulting to off from now on, so it should not be a big
worry. But Alan Brunelle did find that the "10-character limit
in dm/lib/libdm-deptree is too small".

-- 
Jens Axboe

