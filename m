Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYIQSUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYIQSUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbYIQSUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:20:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34674 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbYIQSUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:20:37 -0400
Date: Wed, 17 Sep 2008 20:20:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Lalancette <clalance@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND]: Expand Xen blkfront for > 16 xvd
Message-ID: <20080917182032.GE20055@kernel.dk>
References: <48D0BA0A.1070709@redhat.com> <48D1486F.7060506@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D1486F.7060506@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17 2008, Jeremy Fitzhardinge wrote:
> Chris Lalancette wrote:
> > Until recently, the maximum number of xvd block devices you could attach to
> > a Xen domU was 16.  This limitation turned out to be problematic for some users,
> > so it was expanded to handle a much larger number of disks.  However, this
> > requires a couple of changes in the way that blkfront scans for disks.  This
> > functionality is already present in the Xen linux-2.6.18-xen.hg tree; the
> > attached patch adds this functionality to the mainline xen-blkfront
> > implementation.  I successfully tested it on a 2.6.25 tree, and build tested it
> > on 2.6.27-rc3.
> >
> > Signed-off-by: Chris Lalancette <clalance@redhat.com>
> > Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
> >   
> 
> Jens, do you have this one already?

I do not. Looks fine to me, I'll add it for 2.6.28.

-- 
Jens Axboe

