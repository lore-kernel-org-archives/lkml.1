Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbZD1QJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbZD1QJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbZD1QIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:08:55 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:56253 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZD1QIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:08:54 -0400
Date: Tue, 28 Apr 2009 18:08:46 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CRIS: Wire up syscalls signalfd4 to writev.
Message-ID: <20090428160846.GO21811@axis.com>
References: <20090427081356.GA32167@lst.de> <20090428155856.GN21811@axis.com> <20090428160107.GC26363@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428160107.GC26363@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 06:01:07PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 28, 2009 at 05:58:56PM +0200, Jesper Nilsson wrote:
> > On Mon, Apr 27, 2009 at 10:13:56AM +0200, Christoph Hellwig wrote:
> > > 2.6.30 added the new preadv/pwritev system calls.  The following
> > > architectures still haven't wired them up:
> > > 
> > > 	alpha, avr32, blackfin, cris, frv, h8300, m32r, xtensa
> > > 
> > > Can you maintainers please look into wiring these system calls up?
> > 
> > I've just added the following patch to the CRIS tree:
> > 
> > 
> > Adds sys_signalfd4, sys_eventfd2, sys_epoll_create1, sys_dup3,
> > sys_pipe2, sys_inotify_init1, sys_preadv, sys_pwritev
> > for both CRISv10 and CRISv32.
> 
> Care to send this and your current stack of patches upsteam before
> 2.6.30 is out?

Will do, I'll let it sit for a day in linux-next first.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
