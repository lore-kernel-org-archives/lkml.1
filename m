Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430Ab0AQS3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0AQS3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404Ab0AQS3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:29:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58448 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab0AQS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:29:08 -0500
Date: Sun, 17 Jan 2010 18:29:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kernel@vger.kernel.org, teigland@redhat.com, Matt_Domsch@dell.com,
       maciej.sosnowski@intel.com, hjk@linutronix.de,
       Pekka Enberg <penberg@cs.helsinki.fi>, jens.axboe@oracle.com,
       shemminger@vyatta.com, akpm@linux-foundation.org, davem@davemloft.net,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Constify struct sysfs_ops for v2.6.33-rc4
Message-ID: <20100117182906.GR19799@ZenIV.linux.org.uk>
References: <4B5338D6.2050209@gmail.com> <20100117182537.GQ19799@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117182537.GQ19799@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 06:25:37PM +0000, Al Viro wrote:
> On Sun, Jan 17, 2010 at 05:20:38PM +0100, Emese Revfy wrote:
> 
> > Signed-off-by: Emese Revfy <re.emese@gmail.com>
> > Acked-by: David Teigland <teigland@redhat.com>
> > Acked-by: Matt Domsch <Matt_Domsch@dell.com>
> > Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> > Acked-by: Hans J. Koch <hjk@linutronix.de>
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > Acked-by: Jens Axboe <jens.axboe@oracle.com>
> > Acked-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> NACKed-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Same reason.

BTW, commit 9905a43b2d563e6f89e4c63c4278ada03f2ebb14
Author: Emese Revfy <re.emese@gmail.com>
Date:   Mon Dec 14 00:58:57 2009 +0100

    backlight: Constify struct backlight_ops

is also crap; again, same reason.  Would you please get a clue and stop
pushing that particular bullshit into the tree?
