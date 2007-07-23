Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXGWRz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXGWRz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761990AbXGWRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:55:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761744AbXGWRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:55:48 -0400
Date: Mon, 23 Jul 2007 10:55:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jul 2007, Satyam Sharma wrote:
> 
> The goal is to let gcc generate good, beautiful, optimized code.

No. The point is to let gcc generate *correct* code.

It's either "=m" together with "memory", or it's "+m".

You just introduced a bug.

		Linus
