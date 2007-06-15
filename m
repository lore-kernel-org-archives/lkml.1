Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbXFOVv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbXFOVv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXFOVu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:50:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759241AbXFOVu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:50:57 -0400
Message-ID: <467309BA.8000009@garzik.org>
Date: Fri, 15 Jun 2007 17:50:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk,
       James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
References: <20070615120848.352093000@pademelon.sonytel.be>	<1181918159.25228.543.camel@pmac.infradead.org>	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be> <20070615.141720.112626963.davem@davemloft.net>
In-Reply-To: <20070615.141720.112626963.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> It's senseless to make people build new major/minor numbers for
> all these new quirky storage drivers.  People have to add support
> for the new major number to installers and all kinds of other
> tools.


FWIW that's why libata followed the path it did:  faking SCSI required 
the least amount of code for the maximal amount of existing storage 
driver and platform installer support.

Well, that and the fact that ATAPI is really SCSI, but that's offtopic 
for this thread.  :)

	Jeff


