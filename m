Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYGOSv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYGOSv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYGOSvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:51:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:5822 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYGOSvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:51:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,367,1212390000"; 
   d="scan'208";a="598030463"
Date: Tue, 15 Jul 2008 11:51:23 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Zachary Amsden <zach@vmware.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "yhlu.kernel@gmail.com" <yhlu.kernel@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Message-ID: <20080715185123.GA31445@linux-os.sc.intel.com>
References: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:38:50AM -0700, Zachary Amsden wrote:
> 
> Nacked-by: Zachary Amsden <zach@vmware.com>
> 
> What are you doing here and why aren't you cc-ing the maintainers?

Sorry. I was about to bring you into the loop.

Yinghai posted 32bit native apic_ops(similar to my 64bit apic ops patch, which
is different from pv_apic_ops) which is in tip/x86/x2apic and proposed a fix 
for VMI case aswell.

Based on my understanding, tip/x86/x2apic git commit
94a8c3c2437c8946f1b6c8e0b2c560a7db8ed3c6 is wrong and it should be fixed with
something like
http://marc.info/?l=linux-kernel&m=121614328831237&w=2

Can you please check and Ack/Nack this fix?

thanks,
suresh
