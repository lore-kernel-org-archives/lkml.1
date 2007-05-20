Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbXETWZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbXETWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 18:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbXETWZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 18:25:17 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:32236 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112AbXETWZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 18:25:16 -0400
Date: Sun, 20 May 2007 16:25:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sd_resume redundant?  [was: [PATCH] libata: implement
 ata_wait_after_reset()]
In-reply-to: <20070520115353.4428a735.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: ide <linux-ide@vger.kernel.org>, Indan Zupancic <indan@nul.nu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <4650CABF.9020602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.M0o+I253i7tt/LF97sml0AM+Gec@ifi.uio.no>
 <fa.j/gDhS9FZwWkX/stLhREkTHNbFs@ifi.uio.no>
 <fa.EalQUMJMBHX/KTGV2QFQLG6tYus@ifi.uio.no>
 <fa.Zh3ttZJ9A5tObhEjMLSALUpxCuQ@ifi.uio.no>
 <fa.tQ9LHpM0TOYAYEug36HHMvEVOO0@ifi.uio.no>
 <fa.jSmqI/kJPff3zaVtC404yNL5/Qk@ifi.uio.no> <4650891F.80301@shaw.ca>
 <20070520115353.4428a735.randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 20 May 2007 11:45:03 -0600 Robert Hancock wrote:
> 
>> Indan Zupancic wrote:
>>>>> Everything seems to work fine without sd_resume(), so why is it needed?
>>>> Because not all disks spin up without being told to do so and like it or
>>>> not spinning disks up on resume is the default behavior.  As I wrote in
>>>> the other reply, it would be worthwhile to make it configurable.
>>> Not even after they receive a read command? Ugh.
>> ATA disks are supposed to spin up, yes. SCSI disks require a command to 
>> tell them to spin up if they're in the "stopped" state.
> 
> Good info, but linux-ide was dropped.  Is that due to lack of
> reply-to-all or is it a newsgroup thing or what?

That would be a newsgroup thing. It seems that sometimes CCs get dropped 
when the posts are forwarded to fa.linux.kernel where I normally read them.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

