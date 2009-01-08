Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZAHHy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZAHHy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZAHHyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:54:51 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:46055 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZAHHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:54:50 -0500
Date: Thu, 8 Jan 2009 08:56:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: rmk+kernel@arm.linux.org.uk, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: hardirq.h removal broke sparc64 build...
Message-ID: <20090108075625.GA14179@uranus.ravnborg.org>
References: <20090107.144310.79937111.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107.144310.79937111.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Actually, looking at the patch, where is the part from Alexey
> that does the "fix sparc64"?  I see nothing in the patch that
> would even appear to possibly be for that.  The diffstat is:
> 
>  arch/avr32/kernel/traps.c     |    1 +
>  arch/sh/kernel/traps_32.c     |    1 +
>  drivers/acpi/processor_idle.c |    1 +
>  include/asm-generic/local.h   |    1 -
>  4 files changed, 3 insertions(+), 1 deletion(-)
> 
> Was Alexey's fix removed or lost? :-/

When I made my patch I saw some issues in non-sparc files
but I did not address these as I thought they were generic
bugs addressed by someone else.
I should have checked if the same build error was
also present on x86/arm then :-(

I'm glad to see it is sorted out properly now.

	Sam

