Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZCKLEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZCKLEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZCKLEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:04:16 -0400
Received: from www.tglx.de ([62.245.132.106]:43688 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZCKLEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:04:15 -0400
Date: Wed, 11 Mar 2009 12:03:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: removing zImage support?
In-Reply-To: <20090311102439.GA32512@elte.hu>
Message-ID: <alpine.LFD.2.00.0903111201430.29264@localhost.localdomain>
References: <49B703D4.1000008@zytor.com> <20090311102439.GA32512@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > I'm thinking again about removing zImage support.  An 
> > "allnoconfig" kernel (with CONFIG_EMBEDDED=y to expose 
> > additional knobs, and CONFIG_BINFMT_ELF=y so it can do 
> > anything at all) is currently 487K on i386 -- very close to 
> > the upper limit of 512K for zImage.
> > 
> > Are there *any* residual users of this, or should I just push 
> > a patch to remove it once and for all?
> 
> Havent seen any zImage bugreport for years, so go for it. In the 
> unlikely case of someone still relying on it and having a good 
> use case we'll get a bugreport and can consider putting it back 
> in.

I haven't seen any zImage for years in the embedded space either.
Go for it.

Thanks,

	tglx


