Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZHKO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZHKO7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbZHKO7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:59:19 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:34102 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZHKO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=skRvYaSYVPnQrPxrXz9poaoKzsh1s8c2yLr/y46Ne7TKPtu6yoHdZv35EeBtmvpFNL
         KDgxmtcHRY7z9uDcJ/44OZSfIKvPVXw0cifM56zQi77CpxhQhSftjZbygc3tBRJKzjjh
         A++tZugla/guO5YUSb5Cm3jpH1c1toVC+kq2g=
MIME-Version: 1.0
In-Reply-To: <20090811143919.GU12579@kernel.dk>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
	 <e2e108260908110335tc500412mc6354359d85ae9b6@mail.gmail.com>
	 <20090811143919.GU12579@kernel.dk>
Date: Tue, 11 Aug 2009 16:59:18 +0200
Message-ID: <e2e108260908110759w4fbbb5dejf852ba272fa29d75@mail.gmail.com>
Subject: Re: [PATCH 0/3]: blk-iopoll, a polled completion API for block 
	devices
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Eric.Moore@lsi.com, jeff@garzik.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 4:39 PM, Jens Axboe<jens.axboe@oracle.com> wrote:
> On Tue, Aug 11 2009, Bart Van Assche wrote:
>> On Thu, Aug 6, 2009 at 9:58 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> > Anyway, YMMV, I would appreciate some test results (and as usual, that
>> > even includes just saying that it boots and functions for you). If
>> > people feel adventurous, patches for other controllers will be happily
>> > queued up for testing. I may even be convinced to implement support
>> > for your controller of choice, if you have some fast storage hooked up
>> > and would like to experiment. Generally, adding support to a driver is
>> > not very hard and the two conversions included were also meant to serve
>> > as an inspiration.
>>
>> Sounds very interesting. Have you already considered patching the SRP
>> initiator ? During the SRP performance tests I ran CPU usage on the
>> initiator was more than 95% and on the target less than 10%.
>
> No I haven't, if you point me at which srp files, I can take a look.

The relevant source files are:
include/scsi/srp.h
include/scsi/scsi_transport_srp.h
drivers/infiniband/ulp/srp/ib_srp.h
drivers/infiniband/ulp/srp/ib_srp.c
drivers/scsi/scsi_transport_srp.c
drivers/scsi/libsrp.c
drivers/scsi/scsi_transport_srp_internal.h

Bart.
