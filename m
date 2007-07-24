Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbXGXUYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbXGXUYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXGXUYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:24:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58860 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbXGXUYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:24:18 -0400
Message-ID: <46A65FEF.2030303@garzik.org>
Date: Tue, 24 Jul 2007 16:24:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Micah Gruber <micah.gruber@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in
 mace_interrupt() in drivers/net/pcmcia/nmclan_cs.c
References: <46A567A8.6050409@gmail.com>
In-Reply-To: <46A567A8.6050409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah Gruber wrote:
> This patch fixes a potential null dereference bug where we dereference 
> DEV before a null check. This patch simply moves the dereferencing after 
> the null check.
> 
> Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> 
> ---
> 
> --- a/drivers/net/pcmcia/nmclan_cs.c    +++ 
> b/drivers/net/pcmcia/nmclan_cs.c    @@ -996,7 +996,7 @@

PLEASE PLEASE PLEASE fix your mailer.

None of your patches are apply-able via script or patch(1), which is how 
all Linux maintainers apply patches.

If you want to contribute to the kernel, you -must- figure out how to 
send patches via email.

Linux kernel development is done almost exclusively through email, so it 
is very important to get the details right.

	Jeff



