Return-Path: <linux-kernel-owner+w=401wt.eu-S965809AbXG3AWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965809AbXG3AWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 20:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965520AbXG3AWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 20:22:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965504AbXG3AWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 20:22:34 -0400
Date: Sun, 29 Jul 2007 17:21:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 0/2] Introduce CONFIG_HIBERNATION and CONFIG_SUSPEND
 (updated)
In-Reply-To: <200707292323.29601.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org>
 <alpine.LFD.0.999.0707281130110.3442@woody.linux-foundation.org>
 <200707291220.14880.rjw@sisk.pl> <200707292323.29601.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Ok, I took this, and modified Len's patch to re-introduce ACPI_SLEEP on 
top of it (I took the easy way out, and just made PM_SLEEP imply 
ACPI_SLEEP, which should make everything come out right. I could have 
dropped ACPI_SLEEP entirely in favour of PM_SLEEP, but that would have 
implied changing more of Len's patch than I was really comfy with).

Len, Rafael, please do check that the end result looks ok. 

I suspect ACPI could now take the PM_SLEEP/SUSPEND/HIBERNATE details into 
account, and that some of the code is not necessary when HIBERNATE is not 
selected, for example, but I'm not at all sure that it's worth it being 
very fine-grained.

		Linus
