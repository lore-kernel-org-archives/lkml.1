Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZFZI0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZFZI0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZFZI0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:26:07 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34750 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbZFZI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:26:05 -0400
Subject: Re: kmemleak suggestion (long message)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090626065923.GA14078@elte.hu>
References: <20090625221816.GA3480@localdomain.by>
	 <20090626065923.GA14078@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 26 Jun 2009 09:25:40 +0100
Message-Id: <1246004740.30717.3.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 08:25:41.0438 (UTC) FILETIME=[B14345E0:01C9F637]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 08:59 +0200, Ingo Molnar wrote:
> * Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:
> > Currently kmemleak prints info about all objects. I guess 
> > sometimes kmemleak gives you more than you actually need.
> 
> It prints _a lot_ of info and spams the syslog. I lost crash info a 
> few days ago due to that: by the time i inspected a crashed machine 
> the tons of kmemleak output scrolled out the crash from the dmesg 
> buffer.
> 
> This is not acceptable.
> 
> Instead it should perhaps print _at most_ a single line every few 
> minutes, printing a summary about _how many_ leaked entries it 
> suspects, and should offer a /debug/mm/kmemleak style of file where 
> the entries can be read out from.

I agree as well. It already provides the /sys/kernel/debug/kmemleak
which triggers a scan and shows possible leaks. That's easily fixable.

BTW, this was questioned in the past as well - do we still need the
automatic scanning from a kernel thread? Can a user cron job just read
the kmemleak file?

-- 
Catalin

