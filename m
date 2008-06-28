Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbYF1RDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbYF1RDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbYF1RDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:03:10 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:50474 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYF1RDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:03:09 -0400
Date: Sat, 28 Jun 2008 19:02:58 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Greg KH <greg@kroah.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628190258.6b8a668b@siona.local>
In-Reply-To: <20080628164343.GA11922@kroah.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153403.0870e96c@mjolnir.drzeus.cx>
	<20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com>
	<20080628155913.2bba34a9@mjolnir.drzeus.cx>
	<20080628160752.0fe19753@hskinnemo-gx745.norway.atmel.com>
	<20080628153309.GC11018@kroah.com>
	<20080628180858.4bb1cd5b@hskinnemo-gx745.norway.atmel.com>
	<20080628183736.077263a6@hskinnemo-gx745.norway.atmel.com>
	<20080628164343.GA11922@kroah.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 17:02:59.0544 (UTC) FILETIME=[D1772580:01C8D940]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 09:43:43 -0700
Greg KH <greg@kroah.com> wrote:

> > sh-3.2# rmmod atmel-mci < /sys/kernel/debug/mmc0/ios/clock
> > mmc0: card b368 removed
> > atmel_mci atmel_mci.0: Lost dma0chan1, falling back to PIO
> > sh-3.2# ls /sys/kernel/debug/mmc0/
> > ios
> > 
> > But I'm not sure if that case can be handled in any sane manner.  
> 
> I think we have always been failing this case as I know securityfs also
> has this same issue, and the code base is pretty much identical.
> 
> So don't worry that this patch caused this issue.

Yeah, I'm pretty sure this issue was there before too, when the driver
kept track of things. I just never tested it.

The main reason I tested it now was to make sure it didn't hang, and it
didn't.

> I'll queue it up unless there are any other objections to it.

Thanks.

Haavard
