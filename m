Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXGRJAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXGRJAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbXGRJAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:00:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54067 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbXGRJAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:00:24 -0400
Message-ID: <469DD6A4.7080002@garzik.org>
Date: Wed, 18 Jul 2007 05:00:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] drivers/base/core: improve device_add() error handling,
 fix bugs
References: <20070718055348.GA5734@havoc.gtf.org>	<20070718101501.6af017bc@gondolin.boeblingen.de.ibm.com>	<469DCC4A.9010001@garzik.org>	<20070718083600.GA21650@kroah.com> <20070718105714.2ff2facb@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070718105714.2ff2facb@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 18 Jul 2007 01:36:00 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
>> Or it should be, hm, Cornelia, can you resend it, I seem to have dropped
>> it :(
> 
> Andrew just did :)
> 
> (For reference, here's the patch:)
> 
>> From: akpm@linux-foundation.org
>> To: greg@kroah.com
>> Cc: akpm@linux-foundation.org, cornelia.huck@de.ibm.com
>> Subject: [patch 1/1] Driver core: check return code of sysfs_create_link()
>> Date: Wed, 18 Jul 2007 01:43:47 -0700
>>
>> From: Cornelia Huck <cornelia.huck@de.ibm.com>
>>
>> Check for return value of sysfs_create_link() in device_add() and
>> device_rename().  Add helper functions device_add_class_symlinks() and
>> device_remove_class_symlinks() to make the code easier to read.
>>
>> [akpm@linux-foundation.org: fix unused var warnings]
>> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>> Cc: Greg KH <greg@kroah.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  drivers/base/core.c |  145 ++++++++++++++++++++++++++++++------------
>>  1 file changed, 105 insertions(+), 40 deletions(-)

ACK


