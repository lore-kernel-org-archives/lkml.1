Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbXGTFbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbXGTFbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXGTFa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:30:58 -0400
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:52494 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbXGTFa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:30:57 -0400
Message-ID: <46A05A84.6050305@wolfmountaingroup.com>
Date: Fri, 20 Jul 2007 00:47:32 -0600
From: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.8) Gecko/20050513 Fedora/1.7.8-2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partion table recovery
References: <200707200813.03553.a1426z@gawab.com>
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:

>As always, a good friend of mine managed to scratch my partion table by 
>cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but 
>at least the first 100MB are gone.  I can probably live without the first 
>partion, but there are many partitions after that, which I hope should 
>easily be recoverable.
>
>I tried parted, but it's not working out for me.  Does anybody know of a 
>simple partition recovery tool, that would just scan the disk for lost 
>partions?
>
>
>Thanks!
>
>--
>Al
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
One thing NetWare always did was to stamp a copy of the partition table 
at the time a partition was created as the second logical sector (offset 
1) from the start of a newly created partition. This allowed the disk to 
be scanned for the original (or last) partition table copy.

Jeff
