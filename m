Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbXFBU4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbXFBU4P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 16:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbXFBU4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 16:56:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbXFBU4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 16:56:03 -0400
Date: Sat, 2 Jun 2007 13:55:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tear <tarrqt@yahoo.com>
cc: Len Brown <lenb@kernel.org>, mingo@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IO-APIC blacklist
In-Reply-To: <186376.4823.qm@web63604.mail.re1.yahoo.com>
Message-ID: <alpine.LFD.0.98.0706021353430.23741@woody.linux-foundation.org>
References: <186376.4823.qm@web63604.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jun 2007, Tear wrote:
> > 
> > Wouldn't this also disable the IOAPIC in the (working) ACPI+IOAPIC case?
> 
> Yes, it would. However, I wanted to make my addition
> to the kernel generic so that other people with
> problematic IO-APIC implementations can blacklist
> their systems without checking whether ACPI is enabled
> or not.

But that's just wrong. First off, all distro kernels come with ACPI on, so 
the thing you're fixing is really just for somebody who compiles his own 
kernel in a particular (and unusual/strange) configuration, and you're 
making it _worse_ for everybody else.

And you're blacklisting it without even understaning _what_ is wrong. I 
really think we should figure that part out first,

		Linus
