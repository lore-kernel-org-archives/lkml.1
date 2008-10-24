Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYJXT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYJXT0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYJXT0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:26:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54410 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJXT0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:26:37 -0400
Date: Fri, 24 Oct 2008 21:34:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, akataria@vmware.com,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081024193414.GH27492@one.firstfloor.org>
References: <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com> <20081024002511.GC27492@one.firstfloor.org> <49011AD7.7000901@zytor.com> <20081024072320.GE27492@one.firstfloor.org> <4901EA14.9070300@zytor.com> <20081024192532.GG27492@one.firstfloor.org> <49021FCD.8080209@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49021FCD.8080209@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 12:19:41PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >
> >In the field they will just continue using clock=pit, like they
> >always did on vmware. And also they will not update the Linux kernel.
> >
> 
> That is a totally bogus assumption.  You will typically have the host 
> platform (Vmware in this case) move much much slower than the guests.

The people running on older hypervisors will just continue using
PIT timer. They won't get nohz, but i guess without updates
they don't expect new features.

> >This is strictly for new installations. And I frankly don't 
> >see why Linux needs to get white listed workarounds when the 
> >Hypervisor couldn't as well be fixed. We have the bizarre
> >situation here where a HV vendor tries to add workarounds
> >to Linux instead of fixing it on their products.
> 
> ... just like every other hardware vendor.

Hardware vendors can't fix it without long lead time.
Software vendors can as easily as Linux.

Also we're talking about an optimization here (enabling NOHZ), not a 
correctness issue. So your analogy to hardware workarounds
is already dubious.

-Andi
-- 
ak@linux.intel.com
