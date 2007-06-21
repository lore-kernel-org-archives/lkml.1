Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXFUG7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXFUG7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXFUG7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:59:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47231 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbXFUG7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:59:24 -0400
Date: Thu, 21 Jun 2007 07:59:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Tom Spink <tspink@gmail.com>, Toralf F?rster <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Paolo Giarrusso <blaisorblade@yahoo.it>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: build failure due to ROOT_DEV in mtd module (was Re: linux-2.6.22-rc5-g7c8545e build #298 failed ...)
Message-ID: <20070621065920.GA9792@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Satyam Sharma <satyam.sharma@gmail.com>,
	Tom Spink <tspink@gmail.com>,
	Toralf F?rster <toralf.foerster@gmx.de>,
	linux-kernel@vger.kernel.org,
	Paolo Giarrusso <blaisorblade@yahoo.it>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org
References: <a781481a0706202352u1efed48fo5a101f8c015638d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706202352u1efed48fo5a101f8c015638d7@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 12:22:01PM +0530, Satyam Sharma wrote:
> >> The build seems to fail because of:
> >> ERROR: "ROOT_DEV" [drivers/mtd/maps/nettel.ko] undefined!
> >>
> >> After taking a quick look at the code, I can't immediately see why
> >> this would be, since there is an include for linux/root_dev.h at the
> >> top, there.
> >>
> >> There's only one occurrence of ROOT_DEV (line 425), and after a quick
> >> look at the git history, it seems the include was originally missing,
> >> but was put back in, in commit
> >> 6cc449c7d0292cb9b993f0df84fd3225e3099492.

Please just the reference to ROOT_DEV from this driver.  Just because
someone builds this driver there should be no change in the default root
device.
