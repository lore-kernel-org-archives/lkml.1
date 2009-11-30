Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZK3KTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZK3KTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZK3KTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:19:53 -0500
Received: from bar.sig21.net ([80.81.252.164]:50429 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZK3KTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:19:52 -0500
Date: Mon, 30 Nov 2009 11:21:04 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Robert Hancock <hancockrwd@gmail.com>,
       Mikhail Malygin <mmalygin@ked.de>, Hans Werner <hwerner4@gmx.de>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix
 FailSafe issue?
Message-ID: <20091130102104.GA13288@sig21.net>
References: <20091126164212.GA24421@sig21.net>
 <20091128191932.GB24048@kroah.com>
 <4B11886E.3030906@gmail.com>
 <20091128213446.GA26420@kroah.com>
 <20091128222203.GA369@sig21.net>
 <20091129001745.GA29143@kroah.com>
 <20091129005157.GA6487@sig21.net>
 <4B1387EB.2090506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1387EB.2090506@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.784,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 05:52:59PM +0900, Tejun Heo wrote:
> On 11/29/2009 09:51 AM, Johannes Stezenbach wrote:
> > On Sat, Nov 28, 2009 at 04:17:45PM -0800, Greg KH wrote:
> >> On Sat, Nov 28, 2009 at 11:22:03PM +0100, Johannes Stezenbach wrote:
> >>>
> >>> BTW, at 5min after boot it is 99% guaranteed that this ATA
> >>> exception will happen during the occasional fsck. That
> >>> doesn't feel right.
> >>
> >> Well, I've never been doing a fsck at 5 minutes into boot, and neither do
> >> most Windows users :)
> > 
> > I've been through a lot of reboots with all the testing, and
> > the fsck took longer than 5min, and the ATA exception  struck.
> > fsck continued after the 30 second stall and succeeded.
> 
> The timeout will happen if the C state switching happens while ATA
> command is in flight so unless there's heavy IO load, it's not very
> likely to hit.

I've booted with rdinit=/bin/sh (busybox sh in initramfs), so
nothing accesses the disk.  After 5min the C state switch
happens, but no ATA exception. I waited a few more miniutes
and then used dd if=/dev/sda of=/dev/null  -> ATA exception.
There is no way to escape it.


Johannes
