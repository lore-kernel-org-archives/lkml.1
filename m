Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbXFOVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbXFOVTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbXFOVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:19:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40823
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbXFOVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:19:14 -0400
Date: Fri, 15 Jun 2007 14:19:17 -0700 (PDT)
Message-Id: <20070615.141917.85409547.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk,
       James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070615171545.316dfac7@the-village.bc.nu>
References: <1181918159.25228.543.camel@pmac.infradead.org>
	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	<20070615171545.316dfac7@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 15 Jun 2007 17:15:45 +0100

> > > Any particular reason why this is done as a separate block device driver
> > > rather than as SCSI?
> > 
> > Because no new fake SCSI drivers are accepted anymore.
> 
> Where did drivers/ata come from ;)
> 
> How about making it a fake ata driver if James is being fussy 8)

That sounds like a good idea for my virtual I/O case on
Niagara too actually :-)

Another quirk I have to deal with is that under LDOMs you
can export full disks and also just slices.  So I'll have
to get down into the partition machinery to support that
somehow.
