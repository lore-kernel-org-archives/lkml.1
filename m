Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbXL1FoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbXL1FoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 00:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXL1Fn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 00:43:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbXL1Fn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 00:43:58 -0500
Date: Thu, 27 Dec 2007 21:41:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Suspend code ordering (again)
In-Reply-To: <47744291.30100@shaw.ca>
Message-ID: <alpine.LFD.0.9999.0712272138110.21557@woody.linux-foundation.org>
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <fa.XycBwhGuyvtVl/QW5HONqLwOags@ifi.uio.no> <4773E9EE.40107@shaw.ca> <200712272100.20282.rjw@sisk.pl> <47744291.30100@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Dec 2007, Robert Hancock wrote:
> 
> I doubt they would prefer the later ordering in any way that matters, if the
> Windows version they were designed for uses the earlier ordering.

Well, I wouldn't say it's abotu "preferring" one over the other. It's very 
possible that the BIOS writers were *intending* to prefer ACPI 2.0, and it 
may even be likely that they thought that they wrote it that way, but the 
real issue is that it has apparently never ever been *tested* that way.

So yes, maybe the vendors actually thought they were a good ACPI-2.0 
implementation, but if Windows doesn't do the ordering that the 2.0 spec 
expects, then that is pretty much just a theoretical thing.

But yeah, it would be really nice to have this verified some way. Somebody 
must already know (whether it's a VM person or a BIOS writer, and whether 
they'd tell us, is obviously another issue).

		Linus
