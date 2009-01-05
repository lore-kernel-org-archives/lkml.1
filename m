Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZAEWSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZAEWSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZAEWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:18:05 -0500
Received: from pih-relay05.plus.net ([212.159.14.18]:51872 "EHLO
	pih-relay05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbZAEWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:18:02 -0500
Message-ID: <49628720.6050101@yahoo.com>
Date: Mon, 05 Jan 2009 22:18:08 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
References: <fa.+H1UnEqOmFht/vMPmVy8ellbQi0@ifi.uio.no> <fa.RLz5WOGorLui5GRkc963Ww1kXqg@ifi.uio.no> <fa.x4ejZ7Kj7ZZRu88Sond1Cap6XxY@ifi.uio.no>
In-Reply-To: <fa.x4ejZ7Kj7ZZRu88Sond1Cap6XxY@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: d90d0679bb52e32f9d7b70816a57c6f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, Jan 5, 2009 at 19:54, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Mon, Jan 05 2009, Bartlomiej Zolnierkiewicz wrote:
> 
>>> +static struct queue_sysfs_entry queue_nonrot_entry = {
>>> +     .attr = {.name = "nonrot", .mode = S_IRUGO | S_IWUSR },
>>> +     .show = queue_nonrot_show,
>>> +     .store = queue_nonrot_store,
>>> +};
>>> +
>> Lets please use a better name for export reasons, non-rotational is a
>> lot better. Nobody will know what nonrot means :-)
> 
> What's that negation good for? Can't we just have "rotational", like
> we have "removable" and not "non-removable"? :)

How about cheapseek? fastrandom? flash? ssd? However the internal flag 
is called QUEUE_FLAG_NONROT so it kind of makes sense just to leave it 
as nonrot...
