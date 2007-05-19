Return-Path: <linux-kernel-owner+w=401wt.eu-S1763987AbXESVbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763987AbXESVbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXESVbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:31:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58248 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbXESVbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:31:13 -0400
Message-ID: <464F6C9F.4060503@garzik.org>
Date: Sat, 19 May 2007 17:31:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] sata_sil: Greatly improve DMA support
References: <fa.SqfRJHzGgf3m6sdJPwJTwHDPSuw@ifi.uio.no> <464F2D83.6000506@shaw.ca> <464F6BB1.9050609@garzik.org>
In-Reply-To: <464F6BB1.9050609@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> rotfl.  Boy am I dumb.  I -thought- my patch, written months ago, 
> included that bit.  But obviously it does not.  Let's add that...

Or not.  It just gets rid of the 64k boundary -and- allows for larger 
scatter/gather entries.  LBT does not add 64-bit DMA support.

That answers that :)  Thanks for poking me to take a trip down memory 
lane...

	Jeff


