Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYERKRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYERKRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYERKRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:17:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYERKRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:17:47 -0400
Message-ID: <48300248.7050701@firstfloor.org>
Date: Sun, 18 May 2008 12:17:44 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] kmemcheck: support for x86_64
References: <20080517230458.GA18588@damson.getinternet.no>
In-Reply-To: <20080517230458.GA18588@damson.getinternet.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Most of them look something like this:
> 
> kmemcheck: Caught 8-bit read from freed memory (ffff81000780a904)
> ifffffffifffffffifffffffifffffffifffffffifffffffifffffffifffffff
>     ^
> 
> and my theory so far is that X86_64 uses some currently unhandled
> instruction set extensions like MMX, SSE, etc. (Not 3DNow! because we
> have a dependency for that), for a fairly common operation 

No it shouldn't. Only SSE users are in the (broken) MD RAID code

Most likely you don't decode REX correctly in some cases.

[haven't read the patch sorry]

=Andi


