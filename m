Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYGISsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYGISsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYGISsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:48:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:26322 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbYGISsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,332,1212390000"; 
   d="scan'208";a="9284397"
Date: Wed, 9 Jul 2008 11:48:08 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Message-ID: <20080709184808.GI1678@linux-os.sc.intel.com>
References: <20080708230837.GD1678@linux-os.sc.intel.com> <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com> <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com> <20080709175621.GG1678@linux-os.sc.intel.com> <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 11:05:46AM -0700, Yinghai Lu wrote:
> > BTW, please explain the need for your patch which has more changes, instead
> > of my simple patch which was test booted on 3 different systems with both
> > 32bit and 64bit kernels...
> 
> try to reduce #ifdef CONFIG_X86_64/32, and make 32/64 at the same page.

But it seem to have too many changes included in one patch.

like calls to e820_register_active_regions(), remove_all_active_ranges() 
disappeared all together in this patch.. ??

thanks,
suresh
