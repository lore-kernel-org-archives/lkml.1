Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYGXKht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYGXKht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYGXKhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:37:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYGXKhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:37:40 -0400
Date: Thu, 24 Jul 2008 12:37:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: PIC, L-APIC and I/O APIC debug information
Message-ID: <20080724103724.GG28817@elte.hu>
References: <Pine.LNX.4.55.0807202226310.24038@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807202226310.24038@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Dump all the PIC, local APIC and I/O APIC information at the 
> fs_initcall() level, which is after ACPI (if used) has initialised PCI 
> information, making the point of invocation consistent across MP-table 
> and ACPI platforms.  Remove explicit calls to print_IO_APIC() from 
> elsewhere.  Make the interface of all the functions involved 
> consistent between 32-bit and 64-bit versions and make them all static 
> by default by the means of a New-and-Improved(TM) __apicdebuginit() 
> macro.
> 
>  Note that like print_IO_APIC() all these only output anything if 
> "apic=debug" has been passed to the kernel through the command line.

applied to tip/x86/apic, thanks Maciej.

	Ingo
