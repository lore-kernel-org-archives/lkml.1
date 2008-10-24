Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYJXTSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYJXTSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYJXTR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:17:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJXTR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:17:57 -0400
Date: Fri, 24 Oct 2008 21:25:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, akataria@vmware.com,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081024192532.GG27492@one.firstfloor.org>
References: <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com> <20081024002511.GC27492@one.firstfloor.org> <49011AD7.7000901@zytor.com> <20081024072320.GE27492@one.firstfloor.org> <4901EA14.9070300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4901EA14.9070300@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BIOSes are also just software, and we have to deal with bugs in them 
> *all the time*.  The reality is that we're going to have to deal with 
> both vendor and user reluctance to upgrade, and therefore have to deal 
> with brokenness in the field. 

In the field they will just continue using clock=pit, like they
always did on vmware. And also they will not update the Linux kernel.

This is strictly for new installations. And I frankly don't 
see why Linux needs to get white listed workarounds when the 
Hypervisor couldn't as well be fixed. We have the bizarre
situation here where a HV vendor tries to add workarounds
to Linux instead of fixing it on their products.

Now making generic code a little more flexible in what
it accepts is fine though (like relaxing tsc_sync or 
checking and trusting UNSTABLE_TSC). That will scale at least
and doesn't need significant new code.

-Andi

