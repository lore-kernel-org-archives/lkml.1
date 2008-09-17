Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYIQSMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYIQSMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYIQSL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:11:59 -0400
Received: from gw.goop.org ([64.81.55.164]:37574 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbYIQSL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:11:58 -0400
Message-ID: <48D1486F.7060506@goop.org>
Date: Wed, 17 Sep 2008 11:11:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Chris Lalancette <clalance@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND]: Expand Xen blkfront for > 16 xvd
References: <48D0BA0A.1070709@redhat.com>
In-Reply-To: <48D0BA0A.1070709@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lalancette wrote:
> Until recently, the maximum number of xvd block devices you could attach to
> a Xen domU was 16.  This limitation turned out to be problematic for some users,
> so it was expanded to handle a much larger number of disks.  However, this
> requires a couple of changes in the way that blkfront scans for disks.  This
> functionality is already present in the Xen linux-2.6.18-xen.hg tree; the
> attached patch adds this functionality to the mainline xen-blkfront
> implementation.  I successfully tested it on a 2.6.25 tree, and build tested it
> on 2.6.27-rc3.
>
> Signed-off-by: Chris Lalancette <clalance@redhat.com>
> Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
>   

Jens, do you have this one already?

Thanks,
    J
