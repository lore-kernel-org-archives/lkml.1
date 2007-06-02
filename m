Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbXFBWzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbXFBWzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761910AbXFBWy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:54:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761692AbXFBWyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:54:55 -0400
Date: Sat, 2 Jun 2007 15:54:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tear <tarrqt@yahoo.com>, mingo@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
Message-Id: <20070602155440.c1f8d1cb.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706021400330.23741@woody.linux-foundation.org>
References: <105227.2990.qm@web63604.mail.re1.yahoo.com>
	<alpine.LFD.0.98.0706021400330.23741@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 14:28:58 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That blacklist entry is _ancient_. It's entirely possible that it's just 
> bogus: we've had so many ACPI fixes since it was added, that it's quite 
> possible that the blacklist entry itself is bogus, and is the result of 
> some old ACPI bug that triggered on that entry.
> 
> The Dell GX240 entry was added by commit 68e4ad79294 in the historic Linux 
> archive:
> 
>     Author: Len Brown <len.brown@intel.com>
>     Date:   Sat Aug 9 15:00:59 2003 -0400
> 
>     ACPI from 2.4:
>     build: add ACPI_HT, delete ACPI_HT_ONLY
>     boot: add acpi={force, off, ht}; delete "noht", "acpismp="
>     add DMI blacklist from UnitedLinux
> 
> and since it sounds like the machine _works_ with ACPI on, my real 
> preference would be to just remove the black-list entry.
> 
> In fact, I thought that patch already existed in the -mm tree?

It is.  remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch

> Len - do you have any archives back from 2003 and earlier to indicate why 
> the Dell GX240 was blacklisted?

"add DMI blacklist from UnitedLinux".  Lost in the mists of time, I expect.

I guess we can tag remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch
as "backport to 2.6.22.x if it doesn't break anything in 2.6.23-rcX".
