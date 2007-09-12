Return-Path: <linux-kernel-owner+w=401wt.eu-S934671AbXILQER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671AbXILQER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932502AbXILQEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:04:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42878 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764771AbXILQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:04:04 -0400
Date: Wed, 12 Sep 2007 09:01:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Lossy interrupts on x86_64
Message-Id: <20070912090151.97c9a78e.randy.dunlap@oracle.com>
In-Reply-To: <200709120833.15980.jbarnes@virtuousgeek.org>
References: <200709120833.15980.jbarnes@virtuousgeek.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 08:33:15 -0700 Jesse Barnes wrote:

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

Also tickless?  (NO_HZ ?)

I think I've seen some emails about tickless and keystrokes being
needed to cause interrupts... but I'm not postive about it.

but you said "any ideas"

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
