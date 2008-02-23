Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbYBWWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbYBWWSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 17:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYBWWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 17:18:13 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48828 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbYBWWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 17:18:12 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang 
In-reply-to: <20080222213932.3403F93C12F@tippex.mynet.homeunix.org> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <47BF0DCD.4060400@garzik.org> <20080222185645.9DD9C93C12F@tippex.mynet.homeunix.org> <47BF3DE3.4000100@rtr.ca> <20080222213932.3403F93C12F@tippex.mynet.homeunix.org>
Comments: In-reply-to Anders Eriksson <aeriksson@fastmail.fm>
   message dated "Fri, 22 Feb 2008 22:39:31 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 23 Feb 2008 23:17:21 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080223221721.5C8502DC002@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JT2h5-0001wv-79.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JT2h5-0001wv-79 ce125f12430fbb99e40de48f9cc6df18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


aeriksson@fastmail.fm said:
>> But at this point libata is working much better than the old IDE stuff, and
>> it really is worth moving things over if you can. 
>
> Ok, I'll take a stab at that tomorrow. Two things... 

Having switched to ata_piix i can confirm that smartd doesn't hand the system 
anymore.

Still.. There seem to be a bug vs. the old drivers somewhere. Will that be 
addressed, or should there be a big warning for the old stuff (DEPRECATED?)

/A

