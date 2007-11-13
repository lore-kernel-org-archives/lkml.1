Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbXKMBg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbXKMBg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbXKMBgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:36:20 -0500
Received: from ns.suse.de ([195.135.220.2]:57971 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbXKMBgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:36:20 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arch/x86/kernel/setup_64.c compile error (MMOTM-2007-11-10-19-05)
Date: Tue, 13 Nov 2007 02:32:29 +0100
User-Agent: KMail/1.9.1
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200711112234.lABMYo0n004269@agora.fsl.cs.sunysb.edu> <20071112172841.b4dc21b5.akpm@linux-foundation.org>
In-Reply-To: <20071112172841.b4dc21b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711130232.29900.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> hm, that doesn't seem right.  We want to run the early quirks on non-ACPI
> kernel too, surely?

Most of early-quirks.c makes only sense with ACPI. The only exception would
be the ATI timer override check, but frankly it's fairly unlikely that there 
are any ATI based boards around who still have mptables. Non ACPI 
tables would very likely just run in PIC mode and then need no timer overrides
anyways.

Originally on i386 the early quirks equivalent was 100% ACPI specific.

-Andi
