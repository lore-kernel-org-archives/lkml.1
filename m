Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbXKMBsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbXKMBsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbXKMBsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:48:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756973AbXKMBsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:48:30 -0500
Date: Mon, 12 Nov 2007 17:47:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] arch/x86/kernel/setup_64.c compile error
 (MMOTM-2007-11-10-19-05)
Message-Id: <20071112174721.c304264d.akpm@linux-foundation.org>
In-Reply-To: <200711130232.29900.ak@suse.de>
References: <200711112234.lABMYo0n004269@agora.fsl.cs.sunysb.edu>
	<20071112172841.b4dc21b5.akpm@linux-foundation.org>
	<200711130232.29900.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 02:32:29 +0100 Andi Kleen <ak@suse.de> wrote:

> 
> > hm, that doesn't seem right.  We want to run the early quirks on non-ACPI
> > kernel too, surely?
> 
> Most of early-quirks.c makes only sense with ACPI. The only exception would
> be the ATI timer override check, but frankly it's fairly unlikely that there 
> are any ATI based boards around who still have mptables. Non ACPI 
> tables would very likely just run in PIC mode and then need no timer overrides
> anyways.
> 
> Originally on i386 the early quirks equivalent was 100% ACPI specific.
> 

OK....  But what's The Right Thing To Do here?  Would one be reasonable in
expecting that one can add a new early quirk which is independent from acpi
and have it still work on non-acpi builds?

Seems better to decouple the two things if poss?
