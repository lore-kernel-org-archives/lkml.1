Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXKPPxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXKPPxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXKPPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:53:28 -0500
Received: from ns.suse.de ([195.135.220.2]:42656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbXKPPx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:53:28 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
Date: Fri, 16 Nov 2007 16:53:00 +0100
User-Agent: KMail/1.9.6
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <473CC0AC.3020500@goop.org> <200711161216.46733.ak@suse.de> <473DBB0C.2060808@zytor.com>
In-Reply-To: <473DBB0C.2060808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161653.00824.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007 16:45:16 H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> I think Jeremy's question was due to trying to reduce the 32/64-bit 
> >> differences.  Performance-wise, it might add a small amount to user 
> >> setup time (a typical 32-bit process will need all four, for the main 
> >> binary, libraries, stack and kernel, respectively) 
> > 
> > With the new top down mmap layout and standard 3:1 split it should typically 
> > only need two.
> > 
> 
> Well, three with the kernel.

I didn't count kernel because it is always fixed anyways and about zero
overhead for the normal setup case.

-Andi

