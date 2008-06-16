Return-Path: <linux-kernel-owner+w=401wt.eu-S1761196AbYFPJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbYFPJJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbYFPJJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 05:09:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59533 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756973AbYFPJJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 05:09:07 -0400
Date: Mon, 16 Jun 2008 04:09:04 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616040904.6f684c76.pj@sgi.com>
In-Reply-To: <1213606435.12968.14.camel@caritas-dev.intel.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<1213600062.11185.13.camel@caritas-dev.intel.com>
	<20080616032457.718f4d87.pj@sgi.com>
	<1213606435.12968.14.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> I think it is sufficient for boot loader to avoid memory area from
> 0x9f000 to 0x100000. This can be seen as compatible code for legacy
> BIOS.

That might work -- I'll give it a try.

> I think if EBDA area is used in EFI system, it should be reserved in EFI
> memory map.

Would you recommend doing this with code in arch/x86/kernel/head.c,
that did not invoke reserve_ebda_region() if efi_enabled was set?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
