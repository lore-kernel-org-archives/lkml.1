Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXLFHlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXLFHlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXLFHle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:41:34 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41450 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753130AbXLFHld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:41:33 -0500
Date: Thu, 6 Dec 2007 08:41:31 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
cc: Andrew Morton <akpm@linux-foundation.org>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
In-Reply-To: <47573806.8000808@am.sony.com>
Message-ID: <Pine.LNX.4.62.0712060839340.9929@pademelon.sonytel.be>
References: <47537F2E.2070204@am.sony.com> <b91f94dd5b35247fecf52090c0b3890f@bga.com>
 <Pine.LNX.4.62.0712051013040.28855@pademelon.sonytel.be>
 <20071205151147.9db4640b.akpm@linux-foundation.org> <47573806.8000808@am.sony.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1696839408-1196926891=:9929"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1696839408-1196926891=:9929
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Dec 2007, Geoff Levand wrote:
> Andrew Morton wrote:
> > On Wed, 5 Dec 2007 10:52:48 +0100 (CET)
> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> >> --------------------------------------------------------------------------------
> >> Subject: sparsemem: sparse_add_one_section() may fail to allocate memory
> >> 
> >> sparsemem: sparse_add_one_section() may fail to allocate memory, and must check
> >> whether the allocation succeeded before proceeding to touch the allocated
> >> memory.
> >> 
> >> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> >> 
> >> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> >> ---
> >> FIXME There are still some possible memory leaks in sparse_add_one_section():
> >>   - usemap is never deallocated
> >>   - __kfree_section_memmap() is a not yet implemented dummy
> > 
> > I already had
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
> > and
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
> > 
> > queued.  Do they fix the problem, and should they be merged in 2.6.24?
> 
> No, a quick test shows it just panics in a different place.  Geert's
> patch does also.

What do you mean, that it still paniced after my patch?

The kernel did boot succesfully for me when passing ps3fb=48M. Userspace saw 58
MiB (128 MiB - kernelsize - 48 MiB(ps3fb)).

I did not try kexec, though.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1696839408-1196926891=:9929--
