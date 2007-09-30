Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbXI3BoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbXI3BoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 21:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXI3Bny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 21:43:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbXI3Bnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 21:43:53 -0400
Date: Sat, 29 Sep 2007 21:43:14 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
Message-ID: <20070930014314.GA12669@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <ak@suse.de>
References: <20070928154832.GB12538@wotan.suse.de> <20070928170719.2f617a7a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928170719.2f617a7a@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 05:07:19PM +0100, Alan Cox wrote:
 
 > > Winchip: can any of these CPUs with ooostores do SMP? If not, then smp_wmb
 > > can also be a simple barrier on i386 too.
 > 
 > The IDT Winchip can do SMP apparently.

>From the Winchip3 (which was the final winchip) specs..

"The IDT WinChip 3 processor also omits the software interface
 to the Intel-proprietary symmetric multiprocessing support: APIC.
 This bus function is omitted since the target market for the
 IDT WinChip 3 processor is typical desktop systems (which
 do not support APIC multiprocessing)."

It didn't offer any alternative DIY-SMP either (or at least
none that's documented).

Centaur only became SMP capable with some of the C3 Nehemiah's
a year or two back.

	Dave

-- 
http://www.codemonkey.org.uk
