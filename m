Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbZD1QBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbZD1QBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761618AbZD1QBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:01:10 -0400
Received: from verein.lst.de ([213.95.11.210]:51958 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500AbZD1QBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:01:09 -0400
Date: Tue, 28 Apr 2009 18:01:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Christoph Hellwig <hch@lst.de>, Mikael Starvik <mikael.starvik@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CRIS: Wire up syscalls signalfd4 to writev.
Message-ID: <20090428160107.GC26363@lst.de>
References: <20090427081356.GA32167@lst.de> <20090428155856.GN21811@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428155856.GN21811@axis.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 05:58:56PM +0200, Jesper Nilsson wrote:
> On Mon, Apr 27, 2009 at 10:13:56AM +0200, Christoph Hellwig wrote:
> > 2.6.30 added the new preadv/pwritev system calls.  The following
> > architectures still haven't wired them up:
> > 
> > 	alpha, avr32, blackfin, cris, frv, h8300, m32r, xtensa
> > 
> > Can you maintainers please look into wiring these system calls up?
> 
> I've just added the following patch to the CRIS tree:
> 
> 
> Adds sys_signalfd4, sys_eventfd2, sys_epoll_create1, sys_dup3,
> sys_pipe2, sys_inotify_init1, sys_preadv, sys_pwritev
> for both CRISv10 and CRISv32.

Care to send this and your current stack of patches upsteam before
2.6.30 is out?

