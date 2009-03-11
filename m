Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZCKR0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZCKR0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZCKR0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:26:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZCKR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:26:42 -0400
Message-ID: <49B7F42C.40006@zytor.com>
Date: Wed, 11 Mar 2009 10:26:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>	 <20090310223733.GA4016@elte.hu> <1236786082.3270.20.camel@localhost.localdomain>
In-Reply-To: <1236786082.3270.20.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> 
> That goes for a huge number of drivers we have in the kernel currently,
> and several whole architectures, so it's not a barrier to keeping
> something maintained.
> 
>> nobody but you uses development kernels on it,
> 
> I don't think we've ever had a problem with a downstream community being
> supported by a single upstream developer.
> 

What "downstream community"?  There is none, and you know it.

That is the whole point.  Voyager isn't just a driver -- it's an
odd-man-out variant of the most used architecture in the world.  If it
was just a driver, it would make sense.  However, its very existence
forces constraints on the upstream x86 architecture, and it imposes a
real and considerable workload on the upstream maintainers -- and that
is not you, but on us.  When that happens with drivers for obsolete
hardware, we remove them.

Hence, Ingo rather logically asks you to justify this impact on our
workload.  I would like to know as well.  I'm personally sick of the
extra overhead this museum piece imposes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

