Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXJEMMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXJEMMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbXJEMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:12:48 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55831 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXJEMMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:12:47 -0400
Message-ID: <47062A03.1000603@aitel.hist.no>
Date: Fri, 05 Oct 2007 14:11:47 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: x86-64 sporadic hang in  2.6.23rc7 and 2.6.22
References: <46F8273B.8030904@aitel.hist.no> <1190669351.4035.254.camel@chaos>	<46FE5C98.1030507@aitel.hist.no> <p734phb96cb.fsf@bingen.suse.de>
In-Reply-To: <p734phb96cb.fsf@bingen.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Helge Hafting <helge.hafting@aitel.hist.no> writes:
>   
>> shrink_dcache_memory
>>     
>
> That usually means random memory corruption from somewhere -- dcache
> tends to use a lot of memory and when it is corrupted anywhere these 
> functions tend to crash while walking the lists. 
>
> Unfortunately memory corruption is hard to track down because
> the messenger is usually not the one to blame.
>
> Perhaps enable slab debugging and see if it turns
> something up. Could be also broken hardware. Does an older kernel
> run stable? If yes and if it can be reproduced bisecting would
> be good.
>   
I attempted bisecting - and failed. The problem is that
2.6.23rc7 seems very unstable, but 2.6.22rc4 is much better
but not perfect. 2.6.22rc4 only crashed once - it can compile for
hours and swap lots and keep running. But it died at least once.

I'll try running recent kernels with more debugging instead.
I think I used SLUB instead of SLAB - either way I can switch
that over to see if it changes things.

Helge Hafting

