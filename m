Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYIRPBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYIRPBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYIRPBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:01:33 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:38583 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYIRPBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:01:32 -0400
Date: Thu, 18 Sep 2008 17:00:58 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Timur Tabi <timur@freescale.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Message-ID: <20080918170058.70b562c9@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48D26A74.4030104@freescale.com>
References: <48D02589.8070601@freescale.com>
	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
	<20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
	<48D2664D.7040204@freescale.com>
	<20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
	<48D26A74.4030104@freescale.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Sep 2008 15:00:49.0268 (UTC) FILETIME=[56274B40:01C9199F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> wrote:
> Haavard Skinnemoen wrote:
> 
> > I guess so. What would be even more simple is to simply prevent other
> > clients from taking a channel once someone has acked it, which would be
> > perfect for my purposes, but perhaps not everyone else's...  
> 
> I'm not clear on how your driver works, but doesn't it run continuous tests on
> all channels all the time?  If so, wouldn't your proposal prevent other drivers
> from ever getting a DMA channel?

You can explicitly tell it which channel(s) to use. If you run it on
all channels, it will already prevent any dmaslave clients from ever
getting a channel.

dmatest is meant for testing only, and has a major impact on system
performance when it's running, so it's IMO not a very interesting use
case.

Haavard
