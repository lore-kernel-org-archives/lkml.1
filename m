Return-Path: <linux-kernel-owner+w=401wt.eu-S964819AbXAWMnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbXAWMnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964863AbXAWMnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:43:23 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2945 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819AbXAWMnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:43:22 -0500
Date: Tue, 23 Jan 2007 12:43:12 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-ID: <20070123124312.GD20660@flint.arm.linux.org.uk>
Mail-Followup-To: Alon Bar-Lev <alon.barlev@gmail.com>,
	Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@osdl.org>
References: <20070118152326.GC31418@flint.arm.linux.org.uk> <20070122221400.GE6262@strauss.suse.de> <20070122222725.GB32085@flint.arm.linux.org.uk> <9e0cf0bf0701230237j5aa1bbya3a70da314e471b9@mail.gmail.com> <20070123104140.GA20660@flint.arm.linux.org.uk> <9e0cf0bf0701230250nb8d9738redc3e1d963b40bda@mail.gmail.com> <20070123105331.GB20660@flint.arm.linux.org.uk> <9e0cf0bf0701230331v6001f540p4d7b048126ce7fd@mail.gmail.com> <20070123115405.GC20660@flint.arm.linux.org.uk> <9e0cf0bf0701230359s5e18f51amad23f5677bc5cee4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e0cf0bf0701230359s5e18f51amad23f5677bc5cee4@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 01:59:14PM +0200, Alon Bar-Lev wrote:
> On 1/23/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >> Rossell, I am confused.
> >> There are many places in kernel where there is static __initdata
> >> without initialization. Should all these be corrected too? Or your
> >> comment applies only to none static global data?
> >
> >From what I remembered from previous mails on this list (which is what
> >caused me to pick up on this), and what I later quoted from the gcc
> >manual, all those places (where something is marked __initdata but is
> >not explicitly initialised) would appear to be incorrect.
> >
> >So they should probably be fixed up.
> 
> Well... A lot of places in the kernel needs to be fixed, regardless
> this patch... I can probably creat a patch for this as well... But
> since I don't an expert in this one... We need to be sure this should
> be fixed.

Don't particularly care; the amount of time spent discussing this issue
is becoming rather rediculous, so I'd rather we reached some conclusion
very soon; to this end this is going to be my last response on this
subject.

I suggest that we leave what's already there, but any new instances we
create are correct to the gcc manual.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
