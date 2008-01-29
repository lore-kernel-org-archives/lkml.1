Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbYA2Nnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbYA2Nnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933206AbYA2Nmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:42:47 -0500
Received: from styx.suse.cz ([82.119.242.94]:55507 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933271AbYA2NmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:42:17 -0500
From: David Sterba <dsterba@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Date: Tue, 29 Jan 2008 14:42:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: Randy Dunlap <rdunlap@xenotime.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz,
       stephen@symmetric.co.nz
References: <20080128171929.GA3906@ds.suse.cz> <20080128100854.fe7acad8.rdunlap@xenotime.net> <479E62AB.3010603@gmail.com>
In-Reply-To: <479E62AB.3010603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291442.08740.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 of January 2008 00:18:03 Jiri Slaby wrote:
> On 01/28/2008 07:08 PM, Randy Dunlap wrote:
> >> +/*
> >> + * @return 1 if something has been received from hw
> >
> > What's with the '@'?
>
> ...
>
> >> +
> >> +/*!
> >
> > and the '!' ?
> >
> >> + * @return true if the card is physically present.
> >> + */
>
> What exactly is wrong with @ and !? It's perfectly doxygen-styled.

Well, I've removed them, this was not consistent neither within the driver nor 
with kernel documenting style.

> >> diff --git a/drivers/char/pcmcia/ipwireless/main.c
> >> b/drivers/char/pcmcia/ipwireless/main.c new file mode 100644
> >> index 0000000..cab5722
> >> --- /dev/null
> >> +++ b/drivers/char/pcmcia/ipwireless/main.c
> >> @@ -0,0 +1,496 @@
>
> [...]
>
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

Yes this was my copy&paste error, thanks.

Dave
