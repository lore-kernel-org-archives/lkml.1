Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbXGXNok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbXGXNok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbXGXNoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:44:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55996 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXGXNo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:44:29 -0400
Message-ID: <46A60235.10107@garzik.org>
Date: Tue, 24 Jul 2007 09:44:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
References: <20070716161539.075822000@pademelon.sonytel.be>	<20070716162206.392129000@pademelon.sonytel.be>	<20070718163637.3f0e0164.akpm@linux-foundation.org>	<46A5E610.7000508@shadowen.org> <46A5F275.7060905@garzik.org> <je3aze6k1b.fsf@sykes.suse.de>
In-Reply-To: <je3aze6k1b.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Andy Whitcroft wrote:
>>> Andrew Morton wrote:
>>>
>>>>> +	start_sector = req->sector*priv->blocking_factor;
>>>>> +	sectors = req->nr_sectors*priv->blocking_factor;
>>>> s/*/ * /.  checkpatch missed this.
>>> Ok, this is something we need to decide on.  Currently we only ask for
>>> consistent spacing on all the mathematic operators.  This is mostly as
>>> we do see a large number of non-spaced uses in defines and the like.
>>>
>>> I am happy to expand these tests so they are always spaced on both sides
>>> style if that is the preference.
>> That is most definitely the preference:  spaces surround operators.
>                                                           ^binary

Yes.  :)

	Jeff



