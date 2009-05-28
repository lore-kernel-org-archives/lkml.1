Return-Path: <linux-kernel-owner+w=401wt.eu-S1763274AbZE1S5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274AbZE1S5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZE1S5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:57:17 -0400
Received: from r00tworld.com ([212.85.137.21]:53149 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbZE1S5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:57:16 -0400
From: pageexec@freemail.hu
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 28 May 2009 20:56:55 +0200
MIME-Version: 1.0
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page allocator
Reply-to: pageexec@freemail.hu
CC: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <4A1EDE77.32340.EF6193F@pageexec.freemail.hu>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 28 May 2009 20:56:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2009 at 20:48, Alan Cox , Ingo Molnar wrote:

> last year while developing/debugging something else i also ran some kernel
> compilation tests and managed to dig out this one for you ('all' refers to
> all of PaX):
> 
> ------------------------------------------------------------------------------------------
> make -j4 2.6.24-rc7-i386-pax compiling 2.6.24-rc7-i386-pax (all with SANITIZE, no PARAVIRT)

addendum: i just checked and that version didn't omit GPF_ZERO handling therefore
the current version should have better performance, at least on this kind of workload
where lots of anonymous userland pages are instantiated.

