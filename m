Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXGWQYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXGWQYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbXGWQYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:24:38 -0400
Received: from gw.goop.org ([64.81.55.164]:44990 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759178AbXGWQYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:24:38 -0400
Message-ID: <46A4D612.9050209@goop.org>
Date: Mon, 23 Jul 2007 09:23:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>
> [7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
>
> Another oddity I noticed in this file. The semantics of __volatile__
> when used to qualify inline __asm__ are that the compiler will not
> (1) elid, or, (2) reorder, or, (3) intersperse, our inline asm with
> the rest of the generated code.
>   

"asm volatile" does not mean that at all.  It only guarantees (1), and
only then if the asm is ever reachable.

    J
