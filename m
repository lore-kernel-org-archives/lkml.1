Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbXC3SGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbXC3SGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXC3SGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:06:10 -0400
Received: from smtpout.mac.com ([17.250.248.184]:51053 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbXC3SGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:06:09 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5E1467FD-223A-46DD-9A03-5EA20B5D4842@mac.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: [RFC][PATCH 0/2] Darwinux:  Binary compat support for Mach-O/Darwin in Linux
Date: Fri, 30 Mar 2007 14:05:22 -0400
To: LKML Kernel <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've gotten some time to start working with this code again and I'm  
looking for some review on my first couple patches.  After these two  
patches the code does little more than print out lots of details  
about the binary being run to the syslog and then fail with -ENOEXEC,  
but it's a start.  I'm currently fixing up my icky memory-mapping  
code to avoid allocating big chunks of kernel memory for tables in  
the binary, and once I make some progress on that I'll submit it too.

I'd appreciate any information on what is required in the load_binary  
function in my binfmt.  In particular, if there's anything which fs/ 
binfmt_elf.c does do which is *NOT* required, I'd be interested to  
know what and why.  Thanks for all your assistance.

Cheers,
Kyle Moffett
