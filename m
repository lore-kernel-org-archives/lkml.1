Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbZE2Oax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbZE2Oax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZE2Oap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:30:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:40545 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbZE2Oap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:30:45 -0400
Subject: Re: [PATCH] mtd: Delete final remnants of MTD ioctls from
 fs/compat_ioctl.c
From: David Woodhouse <dwmw2@infradead.org>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Content-Type: text/plain
Date: Fri, 29 May 2009 15:30:12 +0100
Message-Id: <1243607412.19886.169.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 21:59 -0700, Kevin Cernekee wrote:
> Move all MTD compat_ioctl logic into drivers/mtd/mtdchar.c
> 
> Depends on this patch set:
> 
> http://lkml.org/lkml/2009/4/9/52
> http://lkml.org/lkml/2009/4/9/53
> http://lkml.org/lkml/2009/4/9/54
> http://lkml.org/lkml/2009/4/9/55
> 
> Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
> ---
>  drivers/mtd/mtdchar.c |    3 ++-
>  fs/compat_ioctl.c     |   22 ----------------------

Er, that doesn't move stuff into mtdchar.c. It just deletes it...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

