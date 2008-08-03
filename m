Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbYHCXKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbYHCXKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 19:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758840AbYHCXKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 19:10:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53201 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758725AbYHCXKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 19:10:30 -0400
Message-ID: <48963AE1.8080308@garzik.org>
Date: Sun, 03 Aug 2008 19:10:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and	IDE
References: <1217779055.4179.10.camel@localhost.localdomain>
In-Reply-To: <1217779055.4179.10.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Right at the moment, we have two separate subsystems for running IDE
> type devices:  driver/ide and drivers/ata.  The claim I've seen is that
> drivers/ata can do everything drivers/ide can do plus it does sata.  I
> also note that no major distribution seems to enable anything in
> drivers/ide anymore, so given this is it time to deprecate drivers/ide?
> 
> A counter argument to the above is that not all drivers (particularly
> the older ones where hw is scarce) are converted to drivers/ata, so
> drivers/ide seems to be needed for some legacy systems (in which case it
> can be deprecated but not removed).  I've also noted that some embedded
> distributions seem to be using drivers/ide, but I'm not really sure
> whether this is inertia or some overriding need.
> 
> The proposal is to discuss the future of these two subsystems and arrive
> at a consensus what's happening to each going forwards.

I'm not in any rush to change the status quo as I see it: don't remove 
drivers/ide but encourage new drivers to be under libata.

I am a bit disappointed at all the drivers/ide churn.  I had hoped it 
would sit around and be a stable alternative, a fallback to libata.

	Jeff



