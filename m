Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbXGGSGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbXGGSGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXGGSFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:05:54 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:6478 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXGGSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:05:53 -0400
Date: Sat, 07 Jul 2007 12:05:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions
In-reply-to: <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no>
To: caglar@pardus.org.tr
Cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>
Message-id: <468FD5ED.5060401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no>
 <fa.50UJZSgW/ChUl7O1Zks6ydq/1js@ifi.uio.no>
 <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> 06 Tem 2007 Cum tarihinde, Tejun Heo şunları yazmıştı: 
>> S.Çağlar Onur wrote:
>>> [ 4260.278427] ata1.00: cmd ca/00:08:d0:88:bc/00:00:00:00:00/ee tag 0 cdb
>>> 0x0 data 4096 out
>>> [ 4260.278430]          res 51/40:01:d7:88:bc/00:00:0e:00:00/ee Emask 0x9
>>> (media error)
>> That's media error on sector 247236823 on WRITE.  Media errors on write
>> are bad signs - it usually means the drive even failed to remap the
>> sector because extra space ran out. 
> 
> Hmm, more than 50GB is empty on disk :)

It's not the free space on the drive that matters, it's the number of 
free sectors in the spare sector pool on the drive, which is invisible 
to software.

Your SMART log shows 309 reallocated sectors. That seems somewhat high..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

