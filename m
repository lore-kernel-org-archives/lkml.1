Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZAGKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZAGKj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZAGKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:39:46 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:23805 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZAGKjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:39:45 -0500
Message-ID: <4964866D.8010503@msgid.tls.msk.ru>
Date: Wed, 07 Jan 2009 13:39:41 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
References: <200901051952.58029.bzolnier@gmail.com> <20090105185428.GS32491@kernel.dk> <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com> <20090106073515.GY32491@kernel.dk>
In-Reply-To: <20090106073515.GY32491@kernel.dk>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Jan 05 2009, Kay Sievers wrote:
>> On Mon, Jan 5, 2009 at 19:54, Jens Axboe <jens.axboe@oracle.com> wrote:
>>> On Mon, Jan 05 2009, Bartlomiej Zolnierkiewicz wrote:
>>>> +static struct queue_sysfs_entry queue_nonrot_entry = {
>>>> +     .attr = {.name = "nonrot", .mode = S_IRUGO | S_IWUSR },
>>>> +     .show = queue_nonrot_show,
>>>> +     .store = queue_nonrot_store,
>>>> +};
>>>> +
>>> Lets please use a better name for export reasons, non-rotational is a
>>> lot better. Nobody will know what nonrot means :-)
>> What's that negation good for? Can't we just have "rotational", like
>> we have "removable" and not "non-removable"? :)
> 
> Non-rotational is the term typically used, since rotational is the norm
> (still). So I think the negation actually makes sense in this case :-)

You used the word "still" yourself.  I mean, in 5 years SSD will be more
common than rotational media, and "the norm" will be !rotational..
So let's name them correctly and uniformly from the beginning.. ;)

/mjt
