Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbYLPU0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbYLPU0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760006AbYLPUYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:24:42 -0500
Received: from 1wt.eu ([62.212.114.60]:1082 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451AbYLPUYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:24:40 -0500
Date: Tue, 16 Dec 2008 21:24:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ide: fix setting nIEN on idle devices
Message-ID: <20081216202436.GA2506@1wt.eu>
References: <20081213233925.4653.58008.sendpatchset@localhost.localdomain> <20081213233932.4653.97088.sendpatchset@localhost.localdomain> <20081214070620.GB31552@1wt.eu> <200812161957.52419.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161957.52419.bzolnier@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 07:57:52PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 14 December 2008, Willy Tarreau wrote:
> > Hi Bart,
> > 
> > On Sun, Dec 14, 2008 at 12:39:32AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] ide: fix setting nIEN on idle devices
> > > 
> > > Fix do_ide_request() to operate on previous device / port instead of
> > > the current one.  The original code was wrong since at least Feb 2002
> > > (2.4.0 timeframe).
> > 
> > What could be the impact of this bug ? Should I backport your fix to 2.4 ?
> 
> The fix results in better handling of unexpected IRQs on serialized IDE
> ports.  However since unexpected IRQs coming from a device is not something
> we should normally see and I don't recall seeing any bugreports that would
> be potentially closed by this fix I don't think that there is an urgent need
> to backport it (thanks for caring about 2.4.x users anyway!).

OK, thanks Bart !
Willy

