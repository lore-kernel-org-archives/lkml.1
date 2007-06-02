Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbXFBQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbXFBQkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 12:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbXFBQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 12:40:08 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758574AbXFBQkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 12:40:06 -0400
Date: Sat, 2 Jun 2007 09:39:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tear <tarrqt@yahoo.com>
cc: mingo@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IO-APIC blacklist
In-Reply-To: <477357.96605.qm@web63602.mail.re1.yahoo.com>
Message-ID: <alpine.LFD.0.98.0706020938490.23741@woody.linux-foundation.org>
References: <477357.96605.qm@web63602.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jun 2007, Tear wrote:
> 
> I own a Dell OptiPlex GX240 which, when ACPI is disabled
> but IO-APIC is enabled, shows very slow USB performance.
> I thought that this could be related to IO-APIC and
> tried to boot with "noapic" appended to the kernel
> command line. This way the USB transfer speed returned
> to normal values.

Well, it's almost certainly not the IO-APIC per se.

It's more likely to be some irq routing issue, where ACPI fixes up 
something.  Do you have diffs of 'dmesg' with and without ACPI?

		Linus
