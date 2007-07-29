Return-Path: <linux-kernel-owner+w=401wt.eu-S1760313AbXG2Hd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbXG2Hd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 03:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbXG2Hdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 03:33:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:36042 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbXG2Hdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 03:33:49 -0400
Message-ID: <46AC42E6.5010606@qumranet.com>
Date: Sun, 29 Jul 2007 10:33:58 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Stephane Eranian <eranian@hpl.hp.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, mucci@cs.utk.edu,
       linux-mips@linux-mips.org, ak@suse.de, akpm@linux-foundation.org,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] MIPS: add smp_call_function_single()
References: <20070727124451.GC9828@frankl.hpl.hp.com> <20070727125533.GD5118@linux-mips.org> <20070727135323.GF9828@frankl.hpl.hp.com> <20070728091950.GA4642@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070728091950.GA4642@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> This will not do the right thing. Semantics of smp_call_function_single()
> changed recently. It now is supposed to call func() locally with irqs
> disabled if cpu == smp_processor_id(). See i386/x86_64 and powerpc.
> Unfortunately ia64 hasn't been changed yet, so it will behave differently.
>   

A patch for ia64 has been submitted, presumably it's somewhere in the 
pipeline.

-- 
error compiling committee.c: too many arguments to function

