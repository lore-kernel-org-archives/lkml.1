Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYIIOXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYIIOXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYIIOXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:23:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYIIOXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:23:23 -0400
Date: Tue, 9 Sep 2008 08:46:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Message-ID: <20080909124608.GA27837@infradead.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 12:05:45AM -0400, Jarod Wilson wrote:
> The following patch series adds 17 new drivers for assorted infrared and/or RF
> remote control receivers and/or transmitters. These drivers have long lived
> out-of-tree at http://www.lirc.org/, packaged as 3rd-party modules by many
> distributions, and more recently, patched into the kernels of at least Fedora
> and Ubuntu. The primary maintainer of lirc, Christoph Bartelmus simply hasn't
> had the time to send these bits upstream, and a few months back, gave me the
> go-ahead to take on the task.

Any reason this is a separate subsystem instead of just a bunch new
drivers for the input subsystem?

> Not all drivers have been tested with this codebase and certainly not all
> devices they support, but its a solid place to start with these in-kernel.
> Patches are against 2.6.27-rc5-git9 or so, and have been tested running
> the same, at least in the cases where hardware was available. These patches
> are also in the latest nightly Fedora rawhide kernel, for those who want
> instant gratification[3]. Note that you also need the lirc userspace to
> really do any meaningful testing...

Can you first only send the actually tested drivers?  That way review
an cleanup can focus on the core and those few and we might get them
ready for 2.6.28.  Other drivers can than be added when testing and
review is done.

