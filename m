Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbXHTPDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbXHTPDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbXHTPCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:02:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758749AbXHTPCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:02:12 -0400
Date: Mon, 20 Aug 2007 08:01:37 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Kevin E <kevin360@yahoo.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Marvell 88E8056 gigabit ethernet controller
Message-ID: <20070820080137.4112f6c2@freepuppy.rosehill.hemminger.net>
In-Reply-To: <573746.86745.qm@web38903.mail.mud.yahoo.com>
References: <2456F7EB-000C-4B71-B002-64340DD17BA8@linuxmontreal.com>
	<573746.86745.qm@web38903.mail.mud.yahoo.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 18:15:47 -0700 (PDT)
Kevin E <kevin360@yahoo.com> wrote:

> Someone wrote me with a solution to try and so far
> it's working.  They suggested I try the driver up on
> Marvell's website but to make sure I powered off the
> machine completely and when it rebooted to not have
> any of the regular kernel drivers for the Marvell
> chipset to load.  They had found that letting the sky2
> load and then unloading the module would mean the
> vendor's driver wouldn't work.
> 
> So I got down the latest driver package they have
> (10.0.5.3).  At first I couldn't get it compiled
> against kernel 2.6.22.3 that I'm running, but I have
> it compiled with the 2.6.21.5 kernel, which is what
> the machine is running now.  And I'm happy to say that
> it's working fine so far.  I've transfered about 4G
> over the link and it's still working fine.
> 
> Since Marvell's driver seems to be working for the
> 88E8056 chipset and from what I've looked at the code
> it's marked as GPL, could it be rolled into the kernel
> for those of us that have 88E8056 chipsets that are
> working to use? 
> 

Submit for code review, and cleanup the resulting comments.
Good luck.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
