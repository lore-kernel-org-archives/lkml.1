Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbZHLWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbZHLWK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZHLWK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:10:26 -0400
Received: from kroah.org ([198.145.64.141]:54487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZHLWKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:10:25 -0400
Date: Wed, 12 Aug 2009 15:08:33 -0700
From: Greg KH <greg@kroah.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090812220833.GB18647@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <20090812213348.GY13320@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812213348.GY13320@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:33:48PM +0200, Robert Schwebel wrote:
> On Wed, Aug 05, 2009 at 10:15:13AM -0700, Greg KH wrote:
> > Here's the devtmpfs patch again.
> 
> As an embedded distro maintainer, I'd really like such an approach. With
> ptxdist, we can today build the complete rootfs for an embedded system
> without root permissions - just if we want to nfs-root boot the boards
> during development, it doesn't work, because you have to create
> /dev/console, /dev/null and /dev/zero and that works only for root.
> 
> On slow embedded systems (i.e. ARM 200 MHz), note that boot times are
> often much slower than on full-blown x86. So any speed improvement is
> welcome here as well.

That's good to hear, thanks for the response, I appreciate it.

greg k-h
