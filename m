Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYJPMHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYJPMHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYJPMHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:07:32 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:5347 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYJPMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:07:31 -0400
X-BigFish: VPS-34(zz1432R98dR1805M936fO3117Kzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8TZ06-01-29X-01
Date: Thu, 16 Oct 2008 14:06:15 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Greg KH <greg@kroah.com>
CC: stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 0/2] x86: check correctness of IRQ0 override
	on systems with ATI/AMD SB450/SB600 chipsets
Message-ID: <20081016120615.GE29183@alberich.amd.com>
References: <20081015104118.GA4706@alberich.amd.com> <20081015191720.GA7966@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081015191720.GA7966@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Oct 2008 12:06:41.0122 (UTC) FILETIME=[A623BC20:01C92F87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 12:17:20PM -0700, Greg KH wrote:
> On Wed, Oct 15, 2008 at 12:41:18PM +0200, Andreas Herrmann wrote:
> > Hi,
> > 
> > following patches should go into 2.6.27-stable tree.
> > 
> > They fix issues with HP Laptops that provide a wrong override for IRQ0
> > and which change the thermal trip point as soon as Linux unmasks
> > IOAPIC INT2.
> 
> Are these patches in the upstream Linus kernel already?
> 
> If so, can you please give us the git commit ids?

The one for SB450 is upstream. It's commit
33fb0e4eb53f16af312f9698f974e2e64af39c12

The second one was posted yesterday and it is not yet commited.

BTW, I just posted another patch to remove superfluos DMI-quirks
that are related to HP Laptops with SB450/SB600.
IMHO this patch should go into stable as well. But first I'd like
to get a response from Ingo here.


Regards,

Andreas


