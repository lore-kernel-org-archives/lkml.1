Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXJ3DCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXJ3DCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXJ3DCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:02:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:50306 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXJ3DCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:02:13 -0400
In-Reply-To: <20071030024801.GA19417@linux-mips.org>
References: <20071028201549.GA23138@fattire.cabal.ca> <20071030024801.GA19417@linux-mips.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Date: Mon, 29 Oct 2007 22:03:16 -0500
To: Ralf Baechle <ralf@linux-mips.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29, 2007, at 9:48 PM, Ralf Baechle wrote:

> On Sun, Oct 28, 2007 at 04:15:49PM -0400, Kyle McMartin wrote:
>
>> +++ b/mm/Kconfig
>> @@ -172,6 +172,7 @@ config MIGRATION
>>
>>  config RESOURCES_64BIT
>>  	bool "64 bit Memory and IO resources (EXPERIMENTAL)" if (!64BIT  
>> && EXPERIMENTAL)
>> +	depends on (MIPS || PPC32 || X86_PAE) || 64BIT
>
> On MIPS it would be a per platform thing.  I'd prefer if  
> RESOURCES_64BIT
> was enabled through reverse dependencies and never visible as a user
> option.

The same is true on PPC32.  Its a per platform thing.   However, I'm  
not sure if we could hide it from the user.  There are cases on the  
same HW platform that you want to run with just 32-bit phys (for  
performance).

- k
