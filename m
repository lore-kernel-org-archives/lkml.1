Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0BAS4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:56:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:63250 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab0BAS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:56:09 -0500
Message-ID: <4B6723C1.8060100@windriver.com>
Date: Mon, 01 Feb 2010 12:56:01 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain> <4B671865.5030705@windriver.com> <alpine.LFD.2.00.1002011036540.4206@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002011036540.4206@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2010 18:56:00.0995 (UTC) FILETIME=[325AB330:01CAA370]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So x86, sparc and ppc were actually the main targets of the cleanup, the 
> powerpc patch just wasn't ready in time. But it's merged now (got a pull 
> request today), so powerpc should be ok now too (commit 94f28da84: 
> "powerpc: TIF_ABI_PENDING bit removal").
>   

Confirmed.  It works again, and regression tests pass. :-)

Cheers,
Jason.
