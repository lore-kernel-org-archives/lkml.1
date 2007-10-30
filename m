Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXJ3OSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXJ3OSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbXJ3OSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:18:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:52521 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXJ3OSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:18:23 -0400
In-Reply-To: <20071030083719.GJ32359@parisc-linux.org>
References: <20071028201549.GA23138@fattire.cabal.ca> <20071030024801.GA19417@linux-mips.org> <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org> <20071030083719.GJ32359@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C812C5E5-9AA9-42D1-AEE1-679641D1AEB9@kernel.crashing.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Date: Tue, 30 Oct 2007 09:19:31 -0500
To: Matthew Wilcox <matthew@wil.cx>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30, 2007, at 3:37 AM, Matthew Wilcox wrote:

> On Mon, Oct 29, 2007 at 10:03:16PM -0500, Kumar Gala wrote:
>> The same is true on PPC32.  Its a per platform thing.   However, I'm
>> not sure if we could hide it from the user.  There are cases on the
>> same HW platform that you want to run with just 32-bit phys (for
>> performance).
>
> Have you measured what the performance difference is?

I have not.  On some PPC32 systems having proper 36-bit physical  
support usually means growing our pte to be 64-bits which creates  
additional overhead in SW TLB mgmt on these processors.

- k
