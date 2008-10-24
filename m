Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYJXBSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYJXBSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbYJXBSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:18:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbYJXBSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:18:22 -0400
Message-ID: <4901224C.6060003@zytor.com>
Date: Thu, 23 Oct 2008 18:18:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
 set.
References: <20081021181536.GI12825@one.firstfloor.org>	 <1224616236.6161.60.camel@alok-dev1>	 <20081021192746.GJ12825@one.firstfloor.org>	 <1224703427.13953.8.camel@alok-dev1>	 <20081022195845.GP12825@one.firstfloor.org>	 <1224712846.13953.37.camel@alok-dev1>	 <20081022221316.GW12825@one.firstfloor.org>	 <1224713518.13953.46.camel@alok-dev1>	 <20081022225409.GB27492@one.firstfloor.org>	 <1224728478.13953.79.camel@alok-dev1>	 <20081023081052.GI27492@one.firstfloor.org>	 <1224805162.21776.45.camel@alok-dev1>  <49010D1E.8070400@zytor.com> <1224810764.21776.74.camel@alok-dev1>
In-Reply-To: <1224810764.21776.74.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> I agree with the synthetic cpu feature thing.
> Do you think i should use one of the existing word like the word 3 which
> is for synthesized feature bits ? Or is it better to define a new
> virtualization specific word ?
> 

I don't see any point in using anything other than word 3 until it fills up.

What we want to end up with is cleanly separated: hypervisor detection, 
hypervisor features/workaround settings, and the implementation of those.

	-hpa
