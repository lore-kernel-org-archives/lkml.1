Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbYHGVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbYHGVfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYHGVfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:35:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33561 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHGVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:35:11 -0400
Message-ID: <489B6A5C.8030400@kernel.org>
Date: Thu, 07 Aug 2008 14:34:20 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> That can't be done until we know the size of the hole to relocate, which
> isn't known until we probe in the first meg of memory to find the
> associated ROM.  It used to be the case that other things that poked
> around with platform specific memory and checking ROM areas lived around
> here in setup.c, so it was a nice place to put it.  With all the
> abstraction and combination and overifdeffing going on here, that might
> no longer be the case.
> 
> We could move it earlier, but then we'd need another hook to call in
> after max_low_pfn is known.
> 
> Or we could remove the dependency on max_low_pfn and just create a
> liberal linear to physical mapping for lomem which spans all possible
> low memory; then it doesn't matter so much where it is called.
> 

Okay, you lost me about halfway through that... could you perhaps 
describe the problem from the beginning, exactly what you're trying to do?

	-hpa
