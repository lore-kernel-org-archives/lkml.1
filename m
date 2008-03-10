Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYCJRPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYCJRPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYCJRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:15:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbYCJRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:14:59 -0400
Date: Mon, 10 Mar 2008 10:14:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] fix ACPI boot regression (was: Re: Linux 2.6.25-rc5)
In-Reply-To: <20080310170434.GA22430@elte.hu>
Message-ID: <alpine.LFD.1.00.0803101011580.5896@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803092231580.5896@woody.linux-foundation.org> <20080310170434.GA22430@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Mar 2008, Ingo Molnar wrote:
>
> so zero-extending the result in the PCI-BIOS read routine fixes the 
> regression on my laptop. ( It might fix some other long-standing issues 
> we had with PCI-BIOS during the past decade ... ) Both 8-bit and 16-bit 
> accesses were buggy.

Oh, wow. That must have been there forever, but very few people probably 
ever cared.

And why is your laptop using the BIOS routines anyway? Or was that just a 
result of your randconfig having turned off the sane config access 
routines?

		Linus
