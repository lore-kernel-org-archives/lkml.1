Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbXFVU6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbXFVU6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXFVU6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:58:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1217 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751491AbXFVU6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:58:32 -0400
Date: Fri, 22 Jun 2007 20:58:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: castet.matthieu@free.fr
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: FW : airo suspend problem
Message-ID: <20070622205817.GA3885@ucw.cz>
References: <1181985273.4673a9f9e9a4e@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181985273.4673a9f9e9a4e@imp.free.fr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>   Sujet : airo suspend problem
>       ? : linux-pm@lists.osdl.org
> 
> Hi,
> 
> the airo driver (drivers/net/wireless/airo.c) does in its suspend routine [1].
> But not all the pci cards support power management and cause
> pci_enable_wake/pci_set_power_state to return errors.
> 
> On pci card that don't support PM, what should be done ?
> Don't call pci_enable_wake/pci_set_power_state ?

That sounds right. Or simply ignore errors from enable_wake and
set_power_state?

> PS : after the failed suspend to ram due to airo driver, I tried to unload airo
> driver and it hanged. After a reset, I got my ext3 root fs corrupted :(

Corrupted or 'just needed journal replay'?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
