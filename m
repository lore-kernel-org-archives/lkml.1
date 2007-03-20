Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbXCTSY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbXCTSY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXCTSY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:24:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:48526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbXCTSYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:24:24 -0400
Date: Tue, 20 Mar 2007 20:23:26 +0100
From: Andi Kleen <ak@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH 7/9] ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)
Message-ID: <20070320192326.GE4286@bingen.suse.de>
References: <200703201357.50103.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703201357.50103.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +		else if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
> +			  boot_cpu_data.x86 == 6) &&
> +			 (boot_cpu_data.x86_model == 13 ||
> +			  boot_cpu_data.x86_model == 9))

What is with 10..12 and > 13 ? I would just force it for all model 6s that 
have >= C2 and definitely for all with C3.

-Andi

