Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZEIBni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZEIBni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZEIBn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:43:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:37753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZEIBn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:43:28 -0400
Message-ID: <4A04DF32.4050305@kernel.org>
Date: Sat, 09 May 2009 10:41:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tim Connors <tconnors+linuxkml@astro.swin.edu.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: sata_sil24 EH complete
References: <alpine.DEB.2.00.0905060004100.15177@dirac.rather.puzzling.org> <4A00DA98.5060201@kernel.org> <alpine.DEB.2.00.0905061038340.14678@dirac.rather.puzzling.org> <alpine.DEB.2.00.0905090005560.24222@dirac.rather.puzzling.org>
In-Reply-To: <alpine.DEB.2.00.0905090005560.24222@dirac.rather.puzzling.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 09 May 2009 01:41:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Connors wrote:
>>> Hmm... "ata1.00: configured for UDMA/100" means libata part of
>>> configuration went okay but it looks like SCSI probing didn't kick in
>>> for reason.  Is this always reproducible?
>> 100% of time if it is plugged in after boot.
> 
> Hah, I lied.  Not 100% of the time.
> 
> With *some* combination perhaps of
>> for host in 0 1 2 3 ; do ; echo "- - -" > /sys/class/scsi_host/host$host/scan ; done
> and
>> scsiadd -s
> when the drive is plugged in and when it isn't plugged in (or maybe even
> just leaving it alone) and plugging and unplugging it repeadedly,
> eventually (maybe 20% of the time?) it comes good:

I can reliably reproduce it here.  Heh... interesting.  I'll dig in.

Thanks.

-- 
tejun
