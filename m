Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXK3OVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXK3OVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbXK3OU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:20:57 -0500
Received: from styx.suse.cz ([82.119.242.94]:37804 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755810AbXK3OU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:20:56 -0500
Date: Fri, 30 Nov 2007 15:20:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Sterba <dsterba@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
       stephen@symmetric.co.nz, Ben Martel <benm@symmetric.co.nz>
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
In-Reply-To: <47500D95.4020009@garzik.org>
Message-ID: <Pine.LNX.4.64.0711301518320.12807@jikos.suse.cz>
References: <20071130125555.GA10977@ds.suse.cz> <47500D95.4020009@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Jeff Garzik wrote:

> > Driver lives in drivers/char/pcmcia directory, it's a serial driver.  
> > I'm not sure if this is the right place, since it's a networking 
> > driver too and therefore should be in drivers/net/pcmcia.
> If the -main- purpose of the hardware is wireless, it should go in via 
> John Linville, wireless maintainer...

Well, it is

- 4G UMTS PPP networking hardware
- PCMCIA
- which presents itself as a serial character device (i.e. looks like 
  usual modem to userspace, accepts AT commands, etc)

So my opinion is that it's very far away from what actually is in 
drivers/net/wireless. It's not 802.x network card in any sense.

Thanks,

-- 
Jiri Kosina
SUSE Labs
