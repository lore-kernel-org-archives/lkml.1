Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbXHNNFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbXHNNFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXHNNE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:04:56 -0400
Received: from emulex.emulex.com ([138.239.112.1]:61860 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbXHNNEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:04:55 -0400
Message-ID: <46C1A866.5090903@emulex.com>
Date: Tue, 14 Aug 2007 09:04:38 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tore Anderson <tore@linpro.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>
Subject: Re: Linux 2.6.23-rc3
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org> <46C1717E.3030908@linpro.no> <20070814112429.GL16277@parisc-linux.org>
In-Reply-To: <20070814112429.GL16277@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2007 13:04:42.0940 (UTC) FILETIME=[AE403FC0:01C7DE73]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A little more....
The -EEXIST matches http://marc.info/?l=linux-scsi&m=117699334422336&w=2
I had a bug fix at http://marc.info/?l=linux-scsi&m=117856436302690&w=2

Mathew's fix below superceeded my patch and supposedly also corrects it.

-- james s

PS: Emulex's testing has been with my fix. We haven't tested Mathew's yet.

Matthew Wilcox wrote:
> On Tue, Aug 14, 2007 at 11:10:22AM +0200, Tore Anderson wrote:
>>   I gave it a spin, and got quite a few troubles that appears related to
>>  the lpfc driver.  I don't know if these problems happened due to the
>>  recent update as the latest kernel I ran before was 2.6.20 (where I
>>  never saw problems like these).  First I see that something failed when
>>  the volumes on the SAN (on a Sun StorageTek 6140 / Engenio 3994) is
>>  registered, causing two errors errors such as:
> 
> You didn't seem to include your .config, but I assume you're using async
> scanning.  Could you try including this patch:
> 
> http://marc.info/?l=linux-scsi&m=118289275414202&w=2
> 
