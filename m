Return-Path: <linux-kernel-owner+w=401wt.eu-S1765513AbYDVNmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765513AbYDVNmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765415AbYDVNmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:42:14 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:40696 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765414AbYDVNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=B7vdk/LfsHceli9DzuZtfs8dT+fVC9DbNweLQt36rmB7Oc3Pe6HipKlKYmvrHpQMLfHFzMX86GwpN48t8f0Zf31M9bexvSCQJTLTbnqWqIr9AneTCQ1nj5PWx3JiTiCq6YZF6upwpqPhPQhtqfy+U0ZvTp55mr+Qygj51rUKCj4=
Message-ID: <480DEB1F.5060500@gmail.com>
Date: Tue, 22 Apr 2008 22:41:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com>
In-Reply-To: <480DE9E8.2070809@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>>>    Jeff, Tejun, what "sff" in the file name actually means? Isn't it 
>>> strange that the drivers lacking DMA support or not really compliant 
>>> with SFF-8038i have to link with this file?
> 
>> Maybe it should be libata-tf and libata-bmdma, but sff (sans bmdma)
>> and bmdma is acceptable, hopefully, right?
> 
>    What's sff sans bmdma?

Supposed to be TF interface.  IIRC, the SFF term was first from Alan 
although it's entirely possible that I misunderstood it and used it in 
the wrong way.  Alan, can you please clear up the confusion?

-- 
tejun
