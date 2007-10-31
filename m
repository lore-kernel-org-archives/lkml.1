Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbXJaKX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbXJaKX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbXJaKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:23:49 -0400
Received: from 8bytes.org ([88.198.83.132]:54601 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXJaKXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:23:48 -0400
Date: Wed, 31 Oct 2007 11:23:46 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Joerg Roedel <joerg.roedel@amd.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, benjamin.serebrin@amd.com
Subject: Re: Whats the purpose of get_cycles_sync()
Message-ID: <20071031102346.GE29700@8bytes.org>
References: <20071030174452.GA18619@amd.com> <p73sl3s2w29.fsf@bingen.suse.de> <20071030220209.GA21142@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030220209.GA21142@suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vojtech,

On Tue, Oct 30, 2007 at 11:02:09PM +0100, Vojtech Pavlik wrote:
> The K8's still guarantee that subsequent RDTSCs return increasing
> values, even if the processor reorders them.
> 
> What could have been happening then was that the RDTSC instruction might
> have been reordered by the CPU out of the seqlock, causing trouble in
> the calculation.
> 
> Anyway, adding the CPUID didn't solve all the problems we've seen back
> then, and so far none of the approaches for using TSC without acquiring
> a spinlock on multi-socket AMD boxes worked 100% correctly.

Can you tell me more about the problems you have seen or give me a
pointer to a mail discussion regarding that problems? Can you also
provide your test program to me please? I want to understand these
problems a bit better.

Joerg
