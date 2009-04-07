Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZDGKKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZDGKKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZDGKK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:10:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33411 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZDGKK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:10:26 -0400
Date: Tue, 7 Apr 2009 12:09:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 ACPI: Add support for Always Running APIC timer
Message-ID: <20090407100956.GB9462@elte.hu>
References: <20090407015129.GB3493@linux-os.sc.intel.com> <alpine.LFD.2.00.0904070045320.5698@localhost.localdomain> <49DADCB0.9040903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DADCB0.9040903@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Len Brown wrote:
> > applied to acpi-test tree, pending x86 maintainer ack.
> > 
> > thanks,
> > Len Brown, Intel Open Source Technology Center
> > 
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

hm, is this queued for v2.6.30 or v2.6.31?

If v31 then i'd prefer to have it in the x86 tree. The ACPI impact 
is incidental only, 80% of the patch changes x86 files - and it 
changes 'hub' files that frequently cause merge conflicts.

If it's going upstream real soon in v30, then no objections at all:

 Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
