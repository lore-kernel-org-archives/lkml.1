Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYJFOz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYJFOz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYJFOzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:55:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYJFOzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:55:18 -0400
Date: Mon, 6 Oct 2008 07:54:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
 (Re: 2.6.27-rc8+ - first impressions)
In-Reply-To: <200810061159.30103.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Oct 2008, Rafael J. Wysocki wrote:
> 
> Unfortunately some of the recent IO-APIC changes made the bug show
> up.  To prevent this from happening, blacklist machines that are
> known to be affected (nx6115 and 6715b in this particular case).

Can you point to exactly _which_ recent change made it show up? I'd really 
like to know. _What_ was it that made us suddenly need this quirk when it 
wasn't necessary before? I'd like to understand the root cause here.

And how did you even start looking at that strange ACPI override? 

		Linus
