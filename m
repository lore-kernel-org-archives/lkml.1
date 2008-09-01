Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYIAJun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYIAJun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYIAJug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:50:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48076 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbYIAJuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:50:35 -0400
Date: Mon, 1 Sep 2008 11:50:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt() related?
Message-ID: <20080901095032.GK20055@kernel.dk>
References: <4963.1220240176@turing-police.cc.vt.edu> <48BBA0B0.5070309@kernel.org> <7045.1220260558@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7045.1220260558@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01 2008, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:
> 
> > Yeah, I made a mistake converting two of them and devt lookup fails when
> > the disk is zero sized.  Bartlomiej debugged the problem and posted a
> > patch and I followed up with an updated patch.  It should be fine in the
> > next round.
> > 
> >   http://article.gmane.org/gmane.linux.kernel.next/2663
> >   http://article.gmane.org/gmane.linux.kernel.next/2676
> > 
> > If you're seeing other problems, please let me know.
> 
> Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
> does find the LVM volumes and come up.  Thanks for the clue.. :)

Thanks for confirming, both patches are in the updated block branch that
-mm and -next pull down.

-- 
Jens Axboe

