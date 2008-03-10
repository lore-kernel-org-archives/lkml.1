Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbYCJHmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbYCJHmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYCJHmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:42:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:12289 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYCJHmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZYAyyhs4BE9BUZcFSadt1HGK4RSnai2S3sqcVRME86HRS+Pu/R4hWOi8Ia2ZiRTu+qS+P7yAkxaNMqDTdog0FFCV5zxxzCgwsRNOiuIEbelMSYy/tYMHeU8NCPGQVW8tNtCG2Vf9nTRd1IQTTS3bgERsB6rTq+Lk+YFNhNDdAeE=
Message-ID: <47D4E64F.5070106@gmail.com>
Date: Mon, 10 Mar 2008 16:42:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on
 pata_ali
References: <200803082246.47987.rjw@sisk.pl> <20080309073824.902DC82CF2E@smtp04.mtu.ru> <200803100012.27520.rjw@sisk.pl>
In-Reply-To: <200803100012.27520.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>> where ata1 is:
>>>
>>> scsi0 : pata_ali
>>> scsi1 : pata_ali
>> Oh, is it only with audio CDs? I am unable to use DVD on pata_ali in DMA at
>> all. Have you tried to disable ATAPI DMA (libata.dma=1)?
> 
> Data CDs seem to work fine here.

* Does booting into runlevel 1, putting in an audio cd and running
cdparanoia give the same result?

* Does setting module parameter libata.force to "1.00:pio4" make any
difference?

Thanks.

-- 
tejun
