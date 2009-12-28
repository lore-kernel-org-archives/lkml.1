Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZL1QYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZL1QYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZL1QYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:24:22 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:37777 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751200AbZL1QYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:24:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/5] arch/arm: Correct NULL test
Date: Mon, 28 Dec 2009 11:24:19 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F461@mi8nycmail19.Mi8.com>
In-Reply-To: <Pine.LNX.4.64.0912272307310.20548@ask.diku.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] arch/arm: Correct NULL test
Thread-Index: AcqHQaDbtfuuqEwpRpuVrGZLaGNYSQAmDDQg
References: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk><20091227215106.GA18317@pengutronix.de> <Pine.LNX.4.64.0912272307310.20548@ask.diku.dk>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Julia Lawall" <julia@diku.dk>,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: <kernel-janitors@vger.kernel.org>, <linux@arm.linux.org.uk>,
       <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 28 Dec 2009 16:24:19.0892 (UTC) FILETIME=[35375740:01CA87DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 27, 2009 3:08 PM, Julia Lawall wrote:
>>>  	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
>>>  			     GFP_KERNEL);
>>> -	if (!dbgfs_state)
>>> +	if (!dbgfs_chan)
>>>  		goto err_alloc;
>> Shouldn't the malloc line read:
>> 
>> 	... = kmalloc(sizeof(*dbgfs_chan) * ...)
>> 	                      ^^^^^^^^^^
>> 
>> ?
>
> Good point, thanks.  I will send a revised patch.

Wouldn't this be clearer?

	... = kmalloc(sizeof(struct dentry) * ...)

Regards,
Hartley
