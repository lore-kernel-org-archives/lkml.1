Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbXJORpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbXJORpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbXJORo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:44:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33853 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbXJORo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:44:56 -0400
Message-ID: <4713A705.60403@garzik.org>
Date: Mon, 15 Oct 2007 13:44:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
References: <200710112011.22000.rob@landley.net>	<200710141845.44750.rob@landley.net>	<20071015014503.GF9715@thunk.org>	<200710150304.00901.rob@landley.net>	<20071015132106.GE21216@thunk.org> <20071015142945.2cb27911@the-village.bc.nu>
In-Reply-To: <20071015142945.2cb27911@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> You can pull a Model and Serial number via hdparm -i, but it's not as
>> easy to manipulate as a fixed-length MAC address.  That's why people
>> tend to use filesystem UUID's.   
> 
> ATA8 at the moment looks set to add a true "MAC" or "WWN" type identifier
> to each device.. Right now model/serial is not always unique.

WWN was added in ATA-7, AFAICS.

However, I've seen quite a few ATA-7 devices that do not bother to fill 
it in.  I wonder if ATA-8 device firmwares will act with similar 
slackness.  :)

	Jeff



