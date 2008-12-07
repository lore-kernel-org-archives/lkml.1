Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYLGGCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYLGGCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 01:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYLGGCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 01:02:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbYLGGCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 01:02:09 -0500
Date: Sat, 6 Dec 2008 22:00:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
 and resume
In-Reply-To: <20081206152545.326c8b67@infradead.org>
Message-ID: <alpine.LFD.2.00.0812062157590.3425@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org> <200812062236.44111.rjw@sisk.pl> <alpine.LFD.2.00.0812061420190.3425@nehalem.linux-foundation.org> <20081206152545.326c8b67@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Arjan van de Ven wrote:
> 
> the problem is that the system bios can have reassigned interrupts
> after resume, and afaik we need to re-evaluate the ACPI methods to
> get the new mapping.
> So we need to unregister + re-register to make that happen

Can you give actual examples of real life situations?

Because quite frankly, it sounds less and less likely for any relevant 
hardware. It's a non-issue for MSI, for example. And it's a non-issue for 
any sane interrupt source I can think of.

In other words, I've heard that claim before - and I just don't believe 
it. I've never heard a realistic explanation of why it would happen for a 
normal PCI driver. And I still claim that it's a very odd and special case 
if it does.

And btw, I'm talking suspend, not hibernate. 

			Linus
