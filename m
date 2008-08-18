Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYHRRRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYHRRRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYHRRQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:16:57 -0400
Received: from gw.goop.org ([64.81.55.164]:37134 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYHRRQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:16:57 -0400
Message-ID: <48A9AE88.3060507@goop.org>
Date: Mon, 18 Aug 2008 10:16:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Chris Lalancette <clalance@redhat.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Expand Xen blkfront for > 16 xvd
References: <48A400EC.9040407@redhat.com>
In-Reply-To: <48A400EC.9040407@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lalancette wrote:
> Jeremy,
>      Until recently, the maximum number of xvd block devices you could attach to
> a Xen domU was 16.  This limitation turned out to be problematic for some users,
> so it was expanded to handle a much larger number of disks.  However, this
> requires a couple of changes in the way that blkfront scans for disks.  This
> functionality is already present in the Xen linux-2.6.18-xen.hg tree; the
> attached patch adds this functionality to the mainline xen-blkfront
> implementation.

I haven't tested this yet.  You have tested it OK with some pvops
kernel?  If so, send it to Jens Axboe with my ack.

>   I successfully tested it on a 2.6.25 tree.  I build tested it
> on 2.6.27-rc3, but couldn't get that tree to boot due to some other bug.

What other bug?

    J
