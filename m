Return-Path: <linux-kernel-owner+w=401wt.eu-S965266AbXBZNAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266AbXBZNAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965263AbXBZNAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:00:04 -0500
Received: from smtp.nokia.com ([131.228.20.172]:38894 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268AbXBZNAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:00:01 -0500
X-Greylist: delayed 2217 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 07:59:58 EST
Message-ID: <45E2CEB0.8010503@yandex.ru>
Date: Mon, 26 Feb 2007 14:12:32 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/44 take 2] [UBI] kernel-spce API header
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165444.5845.9892.sendpatchset@localhost.localdomain> <20070218013219.GA2997@kroah.com>
In-Reply-To: <20070218013219.GA2997@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Feb 2007 12:12:32.0573 (UTC) FILETIME=[649866D0:01C7599F]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070226141004-6EEC6BB0-6DE9D221/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Are you sure this is the proper license for new kernel code coming from
> IBM these days?  You might want to go verify that the "or any later
> version" is allowed right now...

Hi Greg,

you advised me to use the "class" sysfs category which I did. But I've 
read at LWN that there is a long-term plan to get rid of this category 
altogether. So may I ask you the same question I asked some time ago.

UBI works on top of MTD devices. MTD device may perfectly well support 
the device/driver/bus model. But how this model does not really fit UBI 
because we have no bus.

Please, advice me, should I keep using the "class" category which seems 
fine for me or should I use the device/driver/bus stuff? What do I do 
with bus then? I tried this some time ago and things did not work with 
NULL bus.

Thanks,
Artem.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
