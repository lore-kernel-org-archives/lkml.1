Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbXFOQLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbXFOQLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXFOQLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:11:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59960 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbXFOQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:11:30 -0400
Date: Fri, 15 Jun 2007 17:15:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Message-ID: <20070615171545.316dfac7@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
	<20070615120848.352093000@pademelon.sonytel.be>
	<1181918159.25228.543.camel@pmac.infradead.org>
	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Any particular reason why this is done as a separate block device driver
> > rather than as SCSI?
> 
> Because no new fake SCSI drivers are accepted anymore.

Where did drivers/ata come from ;)

How about making it a fake ata driver if James is being fussy 8)
