Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXBEFgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXBEFgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXBEFgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:36:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbXBEFgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:36:14 -0500
Date: Sun, 4 Feb 2007 21:36:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
Message-Id: <20070204213603.a5bce839.akpm@linux-foundation.org>
In-Reply-To: <45C6BCE5.90103@shaw.ca>
References: <45C6BCE5.90103@shaw.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Feb 2007 23:13:09 -0600 Robert Hancock <hancockr@shaw.ca> wrote:

> Something's busted with forcedeth in 2.6.20-rc6-mm3 for me relative to 
> 2.6.20-rc6. There's no errors in dmesg, but it seems no packets ever get 
> received and so the machine can't get an IP address. I tried reverting 
> all the -mm changes to drivers/net/forcedeth.c, which didn't help. The 
> network controller shares an IRQ with the USB OHCI controller which is 
> receiving interrupts, so it doesn't seem like an interrupt routing 
> problem, though I suppose something wierd could be happening there.
> 
> This is on an Asus A8N-SLI Deluxe (CK804 chipset) on x86_64.
> 
> Any suggestions on how to debug/what to try reverting to see what's 
> causing this?

There are many forcedeth changes in git-netdev-all.patch.  Can you
try reverting drivers/net/forcedeth.c back to the unpatched version
from 2.6.20-rc6?

Thanks.
