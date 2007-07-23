Return-Path: <linux-kernel-owner+w=401wt.eu-S1765759AbXGWR6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765759AbXGWR6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbXGWR6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:58:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757968AbXGWR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:58:29 -0400
Date: Mon, 23 Jul 2007 10:57:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
In-Reply-To: <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0707231056260.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jul 2007, Satyam Sharma wrote:
>
> * The "I" constraint modifier is applicable only to immediate-value operands,
>   and combining it with "r" is bogus.

This is wrong too.

The whole point of a "Ir" modifier is to say that the instruction takes 
*either* an "I" or an "r".

Andrew - the ones I've looked at were all wrong. Please don't take this 
series.

		Linus
