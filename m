Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbXDAV4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbXDAV4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 17:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXDAV4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 17:56:47 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39179 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbXDAV4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 17:56:47 -0400
Date: Sun, 1 Apr 2007 23:55:30 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Petr Vandrovec <petr@vandrovec.name>
cc: bunk@stusta.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc regression in mptbase
In-Reply-To: <20070324010213.GA32620@vana.vc.cvut.cz>
Message-ID: <Pine.LNX.4.61.0704012355070.1245@yvahk01.tjqt.qr>
References: <460475EF.1040109@vc.cvut.cz> <20070324010213.GA32620@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 24 2007 02:02, Petr Vandrovec wrote:
>> > in at least 2.6.21-rc4, one or more of the mptscsi scsi modules is 
>> > broken with respect to not detecting any harddisk (VMware provides that 
>> > virtual LSI MPT controller), which means no working system.
>> > No problems in 2.6.20.2.
>> 
>> Could be a bug in the driver or a bug in the emulation exposed by a 
>> change in the driver.
>> 
>Hello,
>   it is bug in the emulation.  It should be fixed in Workstation 6.0 RC1.  If you
>want to use VMware's LSILogic emulation with older products, you need fix below until
>new releases come out (or unless I'll put out binary patch to fix binaries to
>return 16 instead of previous value).

Yes (workaround works) and rc1 works. Thanks.


Jan
-- 
