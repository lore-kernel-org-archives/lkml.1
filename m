Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbXJZKVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbXJZKVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXJZKU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:20:56 -0400
Received: from www.tglx.de ([62.245.132.106]:41786 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXJZKUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:20:55 -0400
Date: Fri, 26 Oct 2007 12:20:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Huang, Ying" <ying.huang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
In-Reply-To: <1193391002.23935.300.camel@caritas-dev.intel.com>
Message-ID: <alpine.LFD.0.9999.0710261210290.3186@localhost.localdomain>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>  <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>  <1193360591.23935.212.camel@caritas-dev.intel.com>  <alpine.LFD.0.9999.0710261027260.3186@localhost.localdomain>
 <1193391002.23935.300.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Huang, Ying wrote:

> On Fri, 2007-10-26 at 10:48 +0200, Thomas Gleixner wrote:
> > > EFI uses the Windows x86_64 calling convention. The lin2win may be a
> > > more general naming convention that can be used for some other code (the
> > > NDISwrapper?) in the future. Do you agree?
> > 
> > I agree not at all. I do not care whether the EFI creators smoked the
> > Windows-crackpipe or some other hallucinogen when they decided to use
> > this calling convention. We definitely do not want to think about
> > NDISwrapper or any other Windows related hackery in the kernel.
> 
> OK, I will change the name to something like lin2efi.

Can we simply use call_efi_XXX(). lin2efi() sounds like a conversion
routine, but it is not.

	 tglx
