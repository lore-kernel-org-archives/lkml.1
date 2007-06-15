Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXFOViB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXFOViB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbXFOVhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:37:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53344
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbXFOVhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:37:50 -0400
Date: Fri, 15 Jun 2007 14:37:54 -0700 (PDT)
Message-Id: <20070615.143754.28790010.davem@davemloft.net>
To: jeff@garzik.org
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk,
       James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <4673047F.30808@garzik.org>
References: <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	<20070615.141720.112626963.davem@davemloft.net>
	<4673047F.30808@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 15 Jun 2007 17:28:31 -0400

> David Miller wrote:
> > If the SCSI guys were smart, there would be a totally generic helper
> > layer that allows anyone to hook into the SCSI layer as a virtual SCSI
> > disk provider in like 10 lines of code. :-)
> 
> The SCSI target code gives you the capability to do that (the SCSI 
> transport part, the virtual storage part is easy from there).

I don't get to control the server side in my case, I'm a client
talking to something with a pre-determined interface.
