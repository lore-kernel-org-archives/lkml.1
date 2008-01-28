Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbYA1X2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbYA1X2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbYA1X2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:28:15 -0500
Received: from xenotime.net ([66.160.160.81]:50715 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753450AbYA1X2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:28:14 -0500
Date: Mon, 28 Jan 2008 15:28:09 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: dsterba@suse.cz, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz,
       stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-Id: <20080128152809.59d1f52a.rdunlap@xenotime.net>
In-Reply-To: <479E62AB.3010603@gmail.com>
References: <20080128171929.GA3906@ds.suse.cz>
	<20080128100854.fe7acad8.rdunlap@xenotime.net>
	<479E62AB.3010603@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 00:18:03 +0100 Jiri Slaby wrote:

> On 01/28/2008 07:08 PM, Randy Dunlap wrote:
> >> +/*
> >> + * @return 1 if something has been received from hw
> > 
> > What's with the '@'?
> ...
> >> +
> >> +/*!
> > 
> > and the '!' ?
> > 
> >> + * @return true if the card is physically present.
> >> + */
> 
> What exactly is wrong with @ and !? It's perfectly doxygen-styled.

What part of kernel documentation uses doxygen?


> >> diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
> >> new file mode 100644
> >> index 0000000..cab5722
> >> --- /dev/null
> >> +++ b/drivers/char/pcmcia/ipwireless/main.c
> >> @@ -0,0 +1,496 @@
> [...]
> >> +module_param(major, int, 0);
> >> +module_param(ipwireless_debug, int, 0);
> >> +module_param(ipwireless_loopback, int, 0);
> >> +module_param(ipwireless_out_queue, int, 0);
> >> +MODULE_PARM_DESC(major, "ttyIPWp major number [0]");
> >> +MODULE_PARM_DESC(ipwireless_debug, "switch on debug messages [0]");
> >> +MODULE_PARM_DESC(ipwireless_debug, "switch on loopback mode [0]");
> >> +MODULE_PARM_DESC(ipwireless_debug, "set size of outgoing queue [1]");
> > 
> > Will these parameters be documented anywhere?
> 
> Anyway the descs are wrong. Those 3 are for the only one variable.

Ack, thanks.

---
~Randy
