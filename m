Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYFPHFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYFPHFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYFPHEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:04:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:10103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbYFPHEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:04:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,651,1204531200"; 
   d="scan'208";a="397292489"
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
	memory ranges
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Jack Steiner <steiner@sgi.com>,
       Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 15:07:42 +0800
Message-Id: <1213600062.11185.13.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 07:04:44.0757 (UTC) FILETIME=[418C5050:01C8CF7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 23:30 -0700, Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
> 
> In order to support EFI firmware which places the EFI memmap within
> the EBDA (Extended BIOS Data Area), allow for the possibility that we

Boot loader places the EFI memmap,  not EFI firmware. So I think it is
better to change boot loader to avoid memory area of EBDA. Or do not
reserve EBDA on EFI system.

Best Regards,
Huang Ying

