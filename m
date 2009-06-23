Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbZFWPkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbZFWPkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbZFWPjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:39:52 -0400
Received: from www.tglx.de ([62.245.132.106]:42134 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759701AbZFWPjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:39:51 -0400
Date: Tue, 23 Jun 2009 17:39:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
In-Reply-To: <20090623151701.GD30806@kroah.com>
Message-ID: <alpine.LFD.2.00.0906231737580.2767@localhost.localdomain>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com> <20090614230044.GA21624@pengutronix.de> <20090622151515.GA16627@pengutronix.de> <20090622171948.GA15145@kroah.com>
 <alpine.LFD.2.00.0906231216220.2767@localhost.localdomain> <20090623151701.GD30806@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Greg KH wrote:
> > But, after looking into that code I really have to ask you whether you
> > are serious about fixing it instead of rewriting it from scratch and
> > just keep the code as is for reference to the hardware details.
> 
> That is exactly what the code is there for.  There are other groups
> rewriting these drivers from scratch, and hopefully they will be done in
> a kernel release or two and then these drivers can go away.

Ok. I just wondered :)

> If, in the mean time, you don't want them to be built for -rt kernels,
> just send me a Kconfig patch for the individual drivers, not for the
> whole of the staging tree.

Sure, I can mark them individually broken on RT in the -rt patch
itself if we stomp over such issues.

Thanks,

	tglx
