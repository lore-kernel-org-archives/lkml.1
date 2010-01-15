Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0AOCHQ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279Ab0AOCHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:07:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:1522 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab0AOCHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:07:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="484147065"
Subject: Re: [patch 2/4] x86: Do not use hpet MSI as clockevent broadcast
 device
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>, Mark Hounschell <markh@compro.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Alain Knaff <alain@knaff.lu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <4B4FCC33.2010100@zytor.com>
References: <20100115013957.027452000@intel.com>
	 <20100115014209.992004000@intel.com>  <4B4FCC33.2010100@zytor.com>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 18:07:03 -0800
Message-Id: <1263521223.16916.176.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 18:00 -0800, H. Peter Anvin wrote:
> On 01/14/2010 05:39 PM, Venkatesh Pallipadi wrote:
> > Current kernel uses hpet MSI interrupts as both percpu clockevent device
> > and also as clockevent broadcast device in place of IRQ0 timer.
> > There seems to be issues with HPET MSI usage on some platforms. So,
> > restrict it to be only used as a percpu clockevent device.
> 
> Any ideas of which platforms?  It would help avoiding "cargo cult
> programming" in the future.
> 
> Other than that, I presume this is a .33 patch?
> 
> 	-hpa
> 

The problem reported by Mark has only been on (AMD) 790x series chip
sets.

I am not quite sure what the quick-fix for .33 would be.
- Either use dmi to stop using HPET MSI on this chipset
- or stop using HPET MSI altogether, until this complete patchset
provides a better alternative for .34.
I think it should be first option.

Thanks,
Venki

