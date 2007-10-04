Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbXJDVwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbXJDVwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792AbXJDVwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:52:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440AbXJDVwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:52:13 -0400
Message-ID: <47056008.5080600@redhat.com>
Date: Thu, 04 Oct 2007 17:50:00 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
CC: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <m3wsu2u7y6.fsf@bigip.mine.nu>
In-Reply-To: <m3wsu2u7y6.fsf@bigip.mine.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 01:05 PM, Mathieu Chouquet-Stringer wrote:
> In the kernel source tree, if I run a stupid find | xargs ls, I now get
> this:
> xargs: ls: Argument list too long
> 

Can you strace it to see what syscall is failing?
