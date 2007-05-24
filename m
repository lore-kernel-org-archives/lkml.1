Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbXEXRdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbXEXRdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbXEXRdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:33:08 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbXEXRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:33:06 -0400
Date: Thu, 24 May 2007 10:32:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: mjw99@ic.ac.uk,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [Bugme-new] [Bug 8533] New: Panic on boot with early exception
 rip ffffffff8150a240 error 0 cr2 2260
Message-Id: <20070524103249.3e0b87d8.akpm@linux-foundation.org>
In-Reply-To: <200705241523.l4OFN4OZ025419@fire-2.osdl.org>
References: <200705241523.l4OFN4OZ025419@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 08:23:04 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8533
> 
>            Summary: Panic on boot with early exception rip ffffffff8150a240
>                     error 0 cr2 2260
>     Kernel Version: 2.6.21.2
>             Status: NEW
>           Severity: high
>              Owner: ak@suse.de
>          Submitter: mjw99@ic.ac.uk
> 
> 
> Most recent kernel where this bug did *NOT* occur:
> 2.6.18.3 (I've not tried anything between that and 2.6.21.2)
> 
> Distribution:
> [root@f02 ~]# more /etc/redhat-release
> Red Hat Enterprise Linux AS release 4 (Nahant Update 2)
> (but using a kernel.org kernel, not a redhat one)
> 
> Hardware Environment:
> 8CPU Dual Core Opteron; http://www.iwill.net/product_2.asp?p_id=90&sp=Y
> 
> Software Environment:
> Red Hat Enterprise Linux AS release 4 (Nahant Update 2)
> 
> Problem Description:
> Kernel Panics on boot with the following error message sequence:
> 
> Decompressing Linux...done.
> Booting the kernel.
> 
> 
> 
> Kernel alive
> kernel direct mapping tables up to 840000000 @ 8000-2a000
> PANIC: early exception rip ffffffff8150a240 error 0 cr2 2260
> 
> 
> 
> Steps to reproduce:
> 
> 1) Boot the kernel with flags
> kernel /vmlinuz-2.6.21.2 ro root=LABEL=/ selinux=0 console=ttyS0,57600 console=tty0
> 
> 2) Observe the above problem
> 

erk, -stable just went unstable.

hm, it occurred sometime between 2.6.18.3 and 2.6.21.2.  That's a huge
leap.  I don't suppose you'd have the time and inclination to run a
git-bisect search?

