Return-Path: <linux-kernel-owner+w=401wt.eu-S936502AbXGQXTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936502AbXGQXTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbXGQXS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:18:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50851 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934008AbXGQXSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:18:22 -0400
Message-ID: <469D4E37.5040202@garzik.org>
Date: Tue, 17 Jul 2007 19:18:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
References: <469D1D5E.8050609@cateee.net> <200707180045.03352.bzolnier@gmail.com> <alpine.LFD.0.999.0707171535170.27353@woody.linux-foundation.org> <200707180114.56942.bzolnier@gmail.com>
In-Reply-To: <200707180114.56942.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 18 July 2007, Linus Torvalds wrote:
>> On Wed, 18 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
>>> The new generic SG layer is CONFIG_SCSI=y "generic" in the current tree.
>> Yeah. I know, I already talked to Jens about it - in order to be generic, 
>> the BSG stuff really does end up having to be able to stand on its own, 
>> since not everybody wants/needs the whole SCSI layer.
> 
> bsg looks really promising and it would be great if we can use it also
> for IDE driver.

Agreed.  IMO:  bsg should be able to be used for sending ATA commands 
(taskfiles) as well as SCSI commands.

	Jeff



