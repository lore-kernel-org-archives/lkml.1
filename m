Return-Path: <linux-kernel-owner+w=401wt.eu-S1030320AbXDCP0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbXDCP0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXDCP0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:26:46 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:37595 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030320AbXDCP0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:26:45 -0400
Date: Tue, 3 Apr 2007 16:26:37 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Robert Hancock <hancockr@shaw.ca>
cc: Christian Kujau <christian@g-house.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-Reply-To: <4612648D.4090904@shaw.ca>
Message-ID: <Pine.LNX.4.64.0704031620510.3963@sheep.housecafe.de>
References: <fa.P3upyx4QAcXHtp/c/s+b4/cKk5w@ifi.uio.no>
 <fa.u/RjoL2ybMMaAY+GDfTzm7jO5d0@ifi.uio.no> <fa.G7qJfhdvOynxlffny+Xc1kIaqBY@ifi.uio.no>
 <4612648D.4090904@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Robert Hancock wrote:
> These days I think it's usually best to have ACPI on with current systems.

Whooha, really? While I honor the acpi-folks' work when using a desktop 
machine I am otherwise always reminded to the comment in 
arch/i386/kernel/apm.c, which basically says: "write bios code, does it 
compile? does it boot win98? ->ship it" ;))

> Although it's not as bad with servers, many machines are designed to run only 
> Windows (which normally always uses ACPI) and simply aren't tested well or at 
> all with ACPI disabled so you can run into a lot of problems which are just 
> bugs in the BIOS, etc.

I only thought it was the other way around: less (active, used) code - 
less bug (caused by strange ACPI implementations). But I can see your 
point.

> Also, on the server side, if ACPI is disabled you can't take advantage of CPU 
> clock frequency scaling to save power.

I'm happy to do this with the new cpufreq interface, but right now I 
could not care less about saving power :(

Christian.
-- 
BOFH excuse #305:

IRQ-problems with the Un-Interruptible-Power-Supply
