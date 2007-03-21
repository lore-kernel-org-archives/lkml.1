Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbXCUMdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbXCUMdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXCUMdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:33:39 -0400
Received: from www.osadl.org ([213.239.205.134]:44951 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752720AbXCUMdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:33:38 -0400
Subject: Re: Fwd: [PATCH 7/9] ACPI: Only use IPI on known broken machines
	(AMD, Dothan/BaniasPentium M)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070320192326.GE4286@bingen.suse.de>
References: <200703201357.50103.lenb@kernel.org>
	 <20070320192326.GE4286@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 13:40:49 +0100
Message-Id: <1174480849.10840.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 20:23 +0100, Andi Kleen wrote:
> > +		else if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
> > +			  boot_cpu_data.x86 == 6) &&
> > +			 (boot_cpu_data.x86_model == 13 ||
> > +			  boot_cpu_data.x86_model == 9))
> 
> What is with 10..12 and > 13 ? I would just force it for all model 6s that 
> have >= C2 and definitely for all with C3.

C3 is unconditinally anyway.

	tglx


