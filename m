Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYIAJ6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYIAJ6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYIAJ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:58:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYIAJ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:58:39 -0400
Date: Mon, 1 Sep 2008 10:56:51 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, lvm-devel@redhat.com
Subject: Re: [dm-devel] Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt() related?
Message-ID: <20080901095651.GI15123@agk.fab.redhat.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	lvm-devel@redhat.com
References: <4963.1220240176@turing-police.cc.vt.edu> <48BBA0B0.5070309@kernel.org> <7045.1220260558@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7045.1220260558@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 05:15:58AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:
> > Yeah, I made a mistake converting two of them and devt lookup fails when
> > the disk is zero sized.  Bartlomiej debugged the problem and posted a
> > patch and I followed up with an updated patch.  It should be fine in the
> > next round.
> >   http://article.gmane.org/gmane.linux.kernel.next/2663
> >   http://article.gmane.org/gmane.linux.kernel.next/2676
> > If you're seeing other problems, please let me know.
> Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
> does find the LVM volumes and come up.  Thanks for the clue.. :)

I expect we'll need some patches to userspace lvm2 to support these extended
device numbers properly too...

Alasdair (back from holiday)
-- 
agk@redhat.com
