Return-Path: <linux-kernel-owner+w=401wt.eu-S1161251AbXBUOHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161251AbXBUOHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161250AbXBUOHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:07:11 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:20999 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161248AbXBUOHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:07:09 -0500
Date: Wed, 21 Feb 2007 08:06:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata FUA revisited
In-reply-to: <45DC04DF.8040002@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Ric Wheeler <ric@emc.com>,
       Dongjun Shin <d.j.shin@samsung.com>, Hannes Reinecke <hare@suse.de>
Message-id: <45DC51CF.7090202@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no>
 <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca>
 <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca>
 <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk>
 <45D9FE7B.60909@shaw.ca> <45DC04DF.8040002@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> Aside from the issue above, as I mentioned elsewhere, lots of NCQ drives
>> don't support non-NCQ FUA writes..
> 
> To me, using the NCQ FUA bit on such drives doesn't seem to be a good
> idea.  Maybe I'm just too chicken but it's not like we can gain a lot
> from doing FUA at this point.  Are there a lot of drives which support
> NCQ but not FUA opcodes?

Well, it's hard to say whether "lots" have this issue, but the ones I 
have in my machine, Seagate 7200.7 NCQ 160GB (ST3160827AS) and 7200.10 
320GB (ST3320620AS), both support NCQ and don't support non-NCQ FUA, and 
those (especially the latter) seem to be very popular models.

Likely Seagate didn't implement that command since they figured nobody 
would use that if they had NCQ..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

