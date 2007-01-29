Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXA2UJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXA2UJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXA2UJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:09:50 -0500
Received: from www.osadl.org ([213.239.205.134]:37843 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbXA2UJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:09:49 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070129113159.7ad22e4c@freekitty>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 21:10:30 +0100
Message-Id: <1170101430.29240.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 11:31 -0800, Stephen Hemminger wrote:
> Does this fix it?

Don't know.

> --- sky2-2.6.orig/drivers/net/sky2.c	2007-01-29 10:05:12.000000000 -0800
> +++ sky2-2.6/drivers/net/sky2.c	2007-01-29 10:29:56.000000000 -0800
> @@ -3675,6 +3675,12 @@
>  	sky2_write32(hw, B0_IMSK, 0);
>  	sky2_power_aux(hw);
>  

patching file drivers/net/sky2.c
Hunk #1 FAILED at 3675.
Hunk #2 succeeded at 3625 (offset -81 lines).
Hunk #3 succeeded at 3738 with fuzz 1 (offset -1 lines).
Hunk #4 succeeded at 3668 with fuzz 2 (offset -110 lines).
1 out of 4 hunks FAILED -- saving rejects to file drivers/net/sky2.c.rej

# grep -c sky2_power_aux drivers/net/sky2.c
0

Shrug.

	tglx


