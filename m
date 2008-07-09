Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYGISMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYGISMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYGISLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:11:53 -0400
Received: from gw.goop.org ([64.81.55.164]:48228 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYGISLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:11:52 -0400
Message-ID: <4874FF58.5030800@goop.org>
Date: Wed, 09 Jul 2008 11:11:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
References: <20080708230837.GD1678@linux-os.sc.intel.com>	 <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>	 <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com>	 <20080709175621.GG1678@linux-os.sc.intel.com> <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com>
In-Reply-To: <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> try to reduce #ifdef CONFIG_X86_64/32, and make 32/64 at the same page.
>
> could be some regression from early_io_remap unifying from jeremy
>
> please check attached revert patch.

Could my patch "x86_64: there's no need to preallocate 
level1_fixmap_pgt" be a problem in itself?  It seems sound to me, but 
none of my other code has any functional dependency on it; it's really 
just cosmetic.

The unified early_ioremap patch has been kicking around in tip.git for a 
week or more now, and doesn't seem to have caused any problems.

    J
