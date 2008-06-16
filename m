Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYFPJMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYFPJMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 05:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYFPJL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 05:11:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:59016 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYFPJL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 05:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,651,1204531200"; 
   d="scan'208";a="397334586"
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
	memory ranges
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
In-Reply-To: <20080616040904.6f684c76.pj@sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	 <1213600062.11185.13.camel@caritas-dev.intel.com>
	 <20080616032457.718f4d87.pj@sgi.com>
	 <1213606435.12968.14.camel@caritas-dev.intel.com>
	 <20080616040904.6f684c76.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 17:14:19 +0800
Message-Id: <1213607659.13629.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 09:11:22.0516 (UTC) FILETIME=[F22A5540:01C8CF90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 04:09 -0500, Paul Jackson wrote:
> Huang wrote:
> > I think it is sufficient for boot loader to avoid memory area from
> > 0x9f000 to 0x100000. This can be seen as compatible code for legacy
> > BIOS.
> 
> That might work -- I'll give it a try.
> 
> > I think if EBDA area is used in EFI system, it should be reserved in EFI
> > memory map.
> 
> Would you recommend doing this with code in arch/x86/kernel/head.c,
> that did not invoke reserve_ebda_region() if efi_enabled was set?

Yes.

Best Regards,
Huang Ying
