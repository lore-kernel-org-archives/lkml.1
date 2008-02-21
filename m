Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbYBUJd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbYBUJd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYBUJdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:33:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:63409 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbYBUJdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:33:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,385,1199692800"; 
   d="scan'208";a="381807988"
Subject: Re: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
	section into init BSS section
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080221090557.GB20055@elte.hu>
References: <1203581723.4707.20.camel@caritas-dev.intel.com>
	 <20080221090557.GB20055@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Feb 2008 17:28:26 +0800
Message-Id: <1203586106.4707.25.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 21 Feb 2008 09:27:08.0252 (UTC) FILETIME=[EDF331C0:01C8746B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 10:05 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > Uninitialized variable in init DATA sections are relocated into init 
> > BSS sections to reduce kernel image size. Several KB can be reduced.
> 
> > -int __initdata early_ioremap_debug;
> > +int __initbss early_ioremap_debug;
> 
> will we get some sort of build error if we accidentally do:
> 
>    int __initbss early_ioremap_debug = 1;
> 
> ?

I tested it just now, and there is no build error.

Best Regards,
Huang Ying
