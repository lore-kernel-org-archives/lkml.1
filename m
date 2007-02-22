Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbXBVVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbXBVVv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXBVVv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:51:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40220 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbXBVVvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:51:25 -0500
Date: Thu, 22 Feb 2007 13:51:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: michal.k.k.piotrowski@gmail.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH -mm] mmc build fix
Message-Id: <20070222135109.b7685c3d.akpm@linux-foundation.org>
In-Reply-To: <45DE0548.5000307@drzeus.cx>
References: <200702220619.l1M6JsG7006504@shell0.pdx.osdl.net>
	<45DDC7F7.6080205@googlemail.com>
	<45DE0548.5000307@drzeus.cx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Feb 2007 22:04:08 +0100 Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> Michal Piotrowski wrote:
> > Hi,
> > 
> > akpm@linux-foundation.org napisał(a):
> >> The mm snapshot broken-out-2007-02-21-22-18.tar.gz has been uploaded to
> >>
> >>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-21-22-18.tar.gz
> >>
> >> It contains the following patches against 2.6.21-rc1:
> >>
> > 
> > Possible build fix for
> > 
> > drivers/built-in.o: In function `mmc_queue_thread':
> > /mnt/md0/devel/linux-work5/drivers/mmc/card/queue.c:76: undefined reference to `blk_queue_plugged'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> 
> Huh? Is blk_queue_plugged() deprecated?
> 

Jens's tree makes it disappear.

I'll worry about this next week when I get back into action.  It could be
that the offending part of git-block.patch is gone by then.  
