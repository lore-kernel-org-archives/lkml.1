Return-Path: <linux-kernel-owner+w=401wt.eu-S1750923AbXBQQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbXBQQEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXBQQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:04:53 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:58125 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXBQQEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:04:53 -0500
Message-ID: <45D72789.7010801@monatomic.org>
Date: Sat, 17 Feb 2007 18:04:25 +0200
From: Dan Aloni <da-x@monatomic.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Mario Giammarco <mgiammarco-ml@4warding.com>
CC: linux-scsi@vger.kernel.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: LSI Logic 40919o fibre channel: scsi works ip not
References: <200702152306.25374.mgiammarco-ml@4warding.com>
In-Reply-To: <200702152306.25374.mgiammarco-ml@4warding.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mario Giammarco wrote:
> Hello,
>
> I have two lsi logic 40919o 2gbit connected to a 2gbit switch.
>
> They see hard disks but when I try to use them as ip card I obtain a partial 
> failure: packets sometimes arrives sometimes no and on dmesg I see:
>
> mptlan: ioc0/fc0: WARNING - IOC out of buckets! (priv->buckets_out =
> 126)
> mptlan Mismatch between driver's buckets_out count and fw's
> BucketsRemaining count has crossed the threshold, issuing a LanReset
> to clear the fw's hashtable. You may want to check your
> /var/log/messages for "CRC error" event notifications.
> mptlan: ioc0/fc0: WARNING - IOC out of buckets! (priv->buckets_out =
>
>   
AFAIK these messages occur as a result of bad frame tx/rx, and it
doesn't get handled by the hardware/firmware very well, and I'm
quite sure it never did.

Now regarding the whole thing surrounding mptlan, I don't think
that LSI officially supports that feature any more or willing to fix
any bugs for it in their firmware or driver. Is that right?

If so, we might as well remove that driver from the kernel.

-- 
Dan Aloni

