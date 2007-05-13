Return-Path: <linux-kernel-owner+w=401wt.eu-S934389AbXEMRQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbXEMRQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbXEMRQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:16:09 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:45421 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbXEMRQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:16:08 -0400
Date: Sun, 13 May 2007 20:15:55 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-ID: <20070513171555.GA27920@localdomain>
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513092352.18cd80de@freepuppy>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 09:23:52AM -0700, Stephen Hemminger wrote:
> On Sun, 13 May 2007 16:25:17 +0300
> Dan Aloni <da-x@monatomic.org> wrote:
> 
> > Kernel developers might find it useful for quickly getting out from some 
> > rough debugging scenarios.
> > 
> > Signed-off-by: Dan Aloni <da-x@monatomic.org>
> > 
> 
> There is already the modprobe blacklist ability in user space.

Yes, however the point here is that you can easily (and temporarily)
blacklist a module *manually* from the boot loader without needing to 
actually perform a complete and successful boot. Using modprobe's 
blacklist requires editing /etc files, and it also doesn't apply 
for initrd/initramfs or other system/distribution-specific scripts 
that would do hardcoded sequential insmod invocations (for example
on embedded systems that require minimal userspace complexity).

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
