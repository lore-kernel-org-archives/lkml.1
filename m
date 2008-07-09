Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbYGISo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbYGISo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGISoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:44:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:30432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYGISoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:44:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,332,1212390000"; 
   d="scan'208";a="587203015"
Date: Wed, 9 Jul 2008 11:44:06 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Message-ID: <20080709184405.GH1678@linux-os.sc.intel.com>
References: <20080708230837.GD1678@linux-os.sc.intel.com> <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com> <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com> <20080709175621.GG1678@linux-os.sc.intel.com> <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com> <4874FF58.5030800@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4874FF58.5030800@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 11:11:36AM -0700, Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
> > try to reduce #ifdef CONFIG_X86_64/32, and make 32/64 at the same page.
> >
> > could be some regression from early_io_remap unifying from jeremy
> >
> > please check attached revert patch.
> 
> Could my patch "x86_64: there's no need to preallocate
> level1_fixmap_pgt" be a problem in itself?  It seems sound to me, but

Yep. Reverting it made my system with 2GB memory boot fine again.

> none of my other code has any functional dependency on it; it's really
> just cosmetic.

have you test booted it before making this cosmetic change? :)

thanks,
suresh
