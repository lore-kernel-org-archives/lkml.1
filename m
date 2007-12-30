Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbXL3Ofa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbXL3Ofa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXL3OfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:35:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXL3OfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:35:19 -0500
Date: Sun, 30 Dec 2007 15:28:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, tony.luck@intel.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] EFI : Split EFI tables parsing code from EFI
	runtime service support code
Message-ID: <20071230142844.GM16946@elte.hu>
References: <1198910967.17317.47.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198910967.17317.47.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> +struct efi_tables efi_tables;
> +EXPORT_SYMBOL(efi_tables);

> +enum bios_type bios_type = BIOS_LEGACY;
> +EXPORT_SYMBOL(bios_type);

please make all the new exports EXPORT_SYMBOL_GPL().

	Ingo
