Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbXFOV33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbXFOV33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXFOV3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:29:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59855 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbXFOV3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:29:03 -0400
Message-ID: <4673047F.30808@garzik.org>
Date: Fri, 15 Jun 2007 17:28:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, Geert.Uytterhoeven@sonycom.com
CC: dwmw2@infradead.org, axboe@kernel.dk, James.Bottomley@SteelEye.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
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
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

>> Because no new fake SCSI drivers are accepted anymore.

If you can access the firmware/hypervisor code, have that provide SCSI. 
  Then the Linux driver piece is easy, obvious and flexible SCSI, and is 
not "fake."


> If the SCSI guys were smart, there would be a totally generic helper
> layer that allows anyone to hook into the SCSI layer as a virtual SCSI
> disk provider in like 10 lines of code. :-)

The SCSI target code gives you the capability to do that (the SCSI 
transport part, the virtual storage part is easy from there).

	Jeff


