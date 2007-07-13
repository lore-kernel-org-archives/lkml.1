Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbXGMDM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbXGMDM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbXGMDMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:12:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:42465 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbXGMDMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=l0uAkTQMWL4NICm+QTlFdRJE6tRVj58rkyTsB8h6kaibnf+Q0zBpU7Crb4ow15SLPJu9OYExK788d+T5eY7HfEDtuGm1JNzxajABQP/tcoKhTiCea9bZ5NhFQrtoGTNC2eO3skmC2HcR33gGW88X5v6ZNOhS2X7I8ryESC24hQM=
Message-ID: <4696EDAB.10404@gmail.com>
Date: Fri, 13 Jul 2007 12:12:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: caglar@pardus.org.tr, Robert Hancock <hancockr@shaw.ca>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA exceptions
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no> <468FD5ED.5060401@shaw.ca> <200707080035.05718.caglar@pardus.org.tr> <46928066.7000705@gmail.com> <20070712195255.GA6015@ucw.cz>
In-Reply-To: <20070712195255.GA6015@ucw.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>>> Your SMART log shows 309 reallocated sectors. That seems somewhat high..
>>> Ah sorry to misinterpret the content:), its a quiet new piece of hardware (at 
>>> most ~1.5 month old) and  "Reallocated_Event_Count" constantly increases 
>>> (currently its increased to 313) and although i'm not 100 percent sure these 
>>> errors only occured with kernels > 2.6.18 (or 2.6.18 didn't report these 
>>> cause according to kern.log these only visible with 2.6.22+) 
>> OS and driver can't really do much about the reallocation event.  Some
>> number of reallocations is okay but if you it going up constantly, you
>> probably have a dying disk.
> 
> Hmm... cut the power while writing is doable from OS and might force
> reallocations?

Hmmm... We don't have any pending write when power goes out and I don't
emergency unload can directly increase reallocation count.  It can
shorten lifespan of the head tho.

> You might want to check if number of reallocated sectors increases
> with shutdowns/reboots.

I'm curious too.

-- 
tejun
