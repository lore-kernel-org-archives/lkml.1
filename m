Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZEEEFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZEEEFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZEEEFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:05:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:50278 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZEEEFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N3Ng1yFAsYySVLfUl0MkT1nz3Je2mEZaJosr93+Ro1fSj5S/jO9pS13UCH3OzVeM57
         tZLYXqvWg7kANHwhpWkLejqyKPv0VTRnHXRcG1L3TxPMhFMmeGae03dR6adCHEvG0w3H
         xTqH59wUy/g+pFqcKVQakxCjBvipmYVX6Tj+o=
MIME-Version: 1.0
In-Reply-To: <20090505001950.GC29124@cuplxvomd02.corp.sa.net>
References: <20090502023000.GA16076@cuplxvomd02.corp.sa.net>
	 <20090502115539.396206bc@linux-lm>
	 <20090505001950.GC29124@cuplxvomd02.corp.sa.net>
Date: Tue, 5 May 2009 12:05:19 +0800
Message-ID: <d82e647a0905042105g7639fc84g736668c371c40053@mail.gmail.com>
Subject: Re: [PATCH 5/5] initdev:kernel: USB and SCSI block init device 
	notification, v3
From: Ming Lei <tom.leiming@gmail.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/5 David VomLehn <dvomlehn@cisco.com>:
> On Fri, May 01, 2009 at 11:55:39PM -0400, Ming Lei wrote:
>> On Fri, 1 May 2009 19:30:00 -0700
>> David VomLehn <dvomlehn@cisco.com> wrote:
>>
>> > From: Alan Stern <stern@rowland.harvard.edu
>> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> > index 6f51ca4..735b061 100644
>> > --- a/drivers/scsi/scsi_scan.c
>> > +++ b/drivers/scsi/scsi_scan.c
> ...
>> > @@ -1834,6 +1834,7 @@ static int do_scan_async(void *_data)
>> >     struct async_scan_data *data = _data;
>> >     do_scsi_scan_host(data->shost);
>> >     scsi_finish_async_scan(data);
>> > +   initdev_probe_done(BOOTDEV_BLOCK_MASK);
>>
>> Which code are waiting for the block device's probe done?
>
> None yet. That remains to be done.
>

Would you mind submitting  the code path of waitting for probe done to allow a
intact review?  Without the waitting code, it is a a little difficult
to undersand or verify
your patch, IMHO.

Thanks

-- 
Lei Ming
