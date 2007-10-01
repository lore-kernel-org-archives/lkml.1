Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbXJAIlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbXJAIlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXJAIln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:41:43 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:37492 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbXJAIlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:41:42 -0400
Message-ID: <4700B2A0.9040604@aitel.hist.no>
Date: Mon, 01 Oct 2007 10:41:04 +0200
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
2.6.18 had no problem compiling stuff without crashing.
Looks like I have some work to do then.

Helge Hafting
