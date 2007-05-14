Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXENULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXENULu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759742AbXENULd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:11:33 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41733 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759647AbXENULb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:11:31 -0400
Date: Mon, 14 May 2007 22:06:04 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: James Bottomley <James.Bottomley@SteelEye.com>,
       Simon Arlott <simon@fire.lp0.eu>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
In-Reply-To: <20070514194614.4f00655d@the-village.bc.nu>
Message-ID: <Pine.LNX.4.61.0705142204020.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
 <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
 <1179073670.3723.48.camel@mulgrave.il.steeleye.com> <46474E1A.6080904@simon.arlott.org.uk>
 <1179078537.3723.53.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.61.0705141928230.9570@yvahk01.tjqt.qr> <20070514194614.4f00655d@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 19:46, Alan Cox wrote:
>> On May 13 2007 12:48, James Bottomley wrote:
>> >
>> >> Why does ATA select SCSI anyway? Surely PATA doesn't require it?
>> >That's a bit offtopic and to the wrong list.
>> >libata-pata does require SCSI ...
>> 
>> And in the long run, that SCSI parts which are actually used by ATA
>> should be factored out so that SCSI really is SCSI again, and not
>> "Common layer for SCSI, SATA and PATA" or so.
>
>The common layer for the queueing is one thing, but the ATAPI devices
>(CD-ROM etc) are SCSI commands over an ATA bus. A subset of SCSI commands
>badly over an ATA bus but SCSI commands nevertheless - so they have the
>same basic dependancies as USB storage does.

Hm yes of course, but harddisks themselves do not normally need ATAPI;
so it would be cool to be capable of throwing it out for PATA-and-no-CDROM
boxes.


	Jan
-- 
