Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbYJXTUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbYJXTUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYJXTUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:20:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58186 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYJXTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:20:03 -0400
Message-ID: <49021FCD.8080209@zytor.com>
Date: Fri, 24 Oct 2008 12:19:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
 set.
References: <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com> <20081024002511.GC27492@one.firstfloor.org> <49011AD7.7000901@zytor.com> <20081024072320.GE27492@one.firstfloor.org> <4901EA14.9070300@zytor.com> <20081024192532.GG27492@one.firstfloor.org>
In-Reply-To: <20081024192532.GG27492@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> In the field they will just continue using clock=pit, like they
> always did on vmware. And also they will not update the Linux kernel.
> 

That is a totally bogus assumption.  You will typically have the host 
platform (Vmware in this case) move much much slower than the guests.

> This is strictly for new installations. And I frankly don't 
> see why Linux needs to get white listed workarounds when the 
> Hypervisor couldn't as well be fixed. We have the bizarre
> situation here where a HV vendor tries to add workarounds
> to Linux instead of fixing it on their products.

... just like every other hardware vendor.

	-hpa
