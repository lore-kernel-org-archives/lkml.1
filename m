Return-Path: <linux-kernel-owner+w=401wt.eu-S933286AbXCFTmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbXCFTmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933299AbXCFTmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:42:15 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:47301 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286AbXCFTmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:42:14 -0500
Date: Tue, 6 Mar 2007 20:41:23 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bill Davidsen <davidsen@tmr.com>
cc: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 Problems?
In-Reply-To: <45ED9B5B.2030806@tmr.com>
Message-ID: <Pine.LNX.4.61.0703062040510.17131@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703050430280.23714@yvahk01.tjqt.qr>
 <382470.25191.qm@web52508.mail.yahoo.com> <45ED9B5B.2030806@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> > -b internal -- seems like a good idea to speed up
>> > resynchronization.
>> 
>> I'm trying to figure out what the default is. 
>> >  -e 1.0 -- I wonder why the new superblock format
>> > is
>> > not default in mdadm (0.90 is still used).
>> > 
>> 
>> Looks interesting for big arrays but not sure it's
>> worth starting over for. Trying to get through a 2
>> hour sync using 4 500gb sata 2 drives.
>
> That's exactly why you want the bitmap. Fortunately you can add it after the
> array is created. Now the bad news, you should read and understand the meaning
> of the "far" layout. Part of the information is in the mdadm man page under -p,
> some in the md man page. Use of "far" layout will effect the performance of the
> array, the balance of read vs. write performance, and (maybe) the reliability.

So to keep it simple, don't use far unless you have a reason to.


Jan
-- 
