Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbXJDW1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbXJDW1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760195AbXJDW1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:27:43 -0400
Received: from ozlabs.org ([203.10.76.45]:36803 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760187AbXJDW1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:27:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18181.26846.253191.684845@cargo.ozlabs.ibm.com>
Date: Fri, 5 Oct 2007 08:27:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Chouquet-Stringer <mchouque@free.fr>, Ollie Wild <aaw@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
In-Reply-To: <alpine.LFD.0.999.0710041413020.23684@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	<m3wsu2u7y6.fsf@bigip.mine.nu>
	<alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org>
	<20071004204443.GA28483@bigip.bigip.mine.nu>
	<alpine.LFD.0.999.0710041413020.23684@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> Well, since others definitely don't see this, including me, and I can do 
> things like 62MB exec arrays:
> 
> 	[torvalds@woody linux]$ echo $(find /home/torvalds/) | wc
> 	      1  883304 63000962

That wouldn't actually do an exec, assuming you're using bash, since
echo is a shell builtin in bash.  You'd need to do /bin/echo.

Paul.
