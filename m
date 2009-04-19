Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZDSUMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZDSUMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 16:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZDSUMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 16:12:12 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:46289 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZDSUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 16:12:11 -0400
Date: Sun, 19 Apr 2009 17:11:32 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Jeff Garzik <jeff@garzik.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090419201132.GB2891@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca> <49EB1C9C.3000105@msgid.tls.msk.ru> <49EB1FB3.5000609@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49EB1FB3.5000609@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jeff.

On Apr 19 2009, Jeff Garzik wrote:
> Michael Tokarev wrote:
>> Well, the kernel does a good job here in *almost* all cases.
>> The problematic case is when a device has some bad/unreadable
>> blocks/sectors.  When such a place occurs on read, libata
>> (or whatever it is) performs several retries, each time
>> using "less aggressive" settings - like reducing UDMA and
>> PIO mode till the lowest possible PIO/33.  And the device
>> stays in that mode until reboot, even if the problematic
>> sector has been relocated.  So it'd be nice to be able to
>> reset the mode back in such cases.
>
> Do you have a log?

I have a log here of libata reducing UDMA speed. I don't know if this is
any hardware problem or not (I think not), but I do see libata
complaining and reducing the speed of the drive.

Would you like it?


Thanks,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
