Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXIMNl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXIMNl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXIMNlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:41:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXIMNlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:41:18 -0400
Message-ID: <46E93DDC.7090207@redhat.com>
Date: Thu, 13 Sep 2007 09:40:44 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Lossy interrupts on x86_64
References: <200709120833.15980.jbarnes@virtuousgeek.org>
In-Reply-To: <200709120833.15980.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> I just narrowed down a weird problem where I was losing more than 50% of 
> my vblank interrupts to what seems to be the hires timers patch.  Stock 
> 2.6.23-rc5 works fine, but the latest (171) kernel from rawhide drops 
> most of my interrupts unless I also have another interrupt source 
> running (e.g. if I hold down a key or move the mouse I get the expected 
> number of vblank interrupts, otherwise I get between 3 and 30 instead 
> of the expected 60 per second).
> 
> Any ideas?  It seems like it might be bad APIC programming, but I 
> haven't gone through those mods to look for suspects...

What happens if you boot with 'noapic' or 'pci=nomsi'?  Please post dmesg as 
well so we can see how the kernel is initializing the relevant hardware.

	-- Chris
