Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbYGHWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbYGHWKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYGHWKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:10:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60344 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYGHWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:10:16 -0400
Date: Wed, 9 Jul 2008 00:11:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Brown, Len" <len.brown@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       "Moore, Robert" <robert.moore@intel.com>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Huang Cheng <cheng.huang@intel.com>, firmwarekit-discuss@bughost.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70]
	ACPICA: Workaround for reversed _PRT entries from BIOS
Message-ID: <20080708221110.GC18195@elf.ucw.cz>
References: <1213947852-10924-1-git-send-email-lenb@kernel.org> <deade3c973eb9c98d2a6cfed658bbb49e693894a.1213947350.git.len.brown@intel.com> <200807011033.27887.trenn@suse.de> <20080707111207.GH5643@ucw.cz> <48738A65.9060905@linux.intel.com> <960B77DF2E6D974DBE24FD066EAEE8DAD90886@azsmsx422.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B77DF2E6D974DBE24FD066EAEE8DAD90886@azsmsx422.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> FIRMWARE_BUG_ON(severity, description, component);
> >> 
> >> Yes, please.
> 
> I'm not excited about maintaining
> maintaining linux-as-a-firmware-diagnostic --
> particularly when...
> 
> 1. it clutters the code for normail machines
> 2. finding the bug is pointless, because even
>    if you fix one machine, you are guaranteed to
>    not fix all machines and thus must maintain
>    the workaround anyway.

Well, at least we can make sure new machines are okay.

Plus, it is nice to know how common hw/BIOS problems are.

> >> I'd also like HARDWARE_BUG_ON(), with similar usage.
> >> 
> >> With all the preload-linux-on-foo project, we have some 
> >> chance to make
> >> BIOS vendors fix their stuff if we can easily diagnose errors in
> >> there.
> 
> These customers should be running 
> http://linuxfirmwarekit.org/
> 
> We do maintain some degree of "high-road ACPI spec checking"
> with the "acpi=strict" boot option.  If we do more of this,
> I think it should stay under that option.

That's okay with me, but it would be nice to have printk() markup, so
that we can tell BIOS/hw bugs from normal kernel messages.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
