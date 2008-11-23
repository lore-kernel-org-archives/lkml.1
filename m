Return-Path: <linux-kernel-owner+w=401wt.eu-S1751095AbYKWXfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbYKWXfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKWXez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:34:55 -0500
Received: from main.gmane.org ([80.91.229.2]:44837 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYKWXez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:34:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: Kernel bug: unable to handle kernel NULL pointer dereference
   at ...
Date: Sun, 23 Nov 2008 17:34:44 -0600
Message-ID: <4929E894.7090103@shaw.ca>
References: <49297820.9040406@edumail.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <49297820.9040406@edumail.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johann Wöckinger wrote:
> Hello,
> 
> 1. on resume my machine vom S3, I got a kernel Oops (see below)
> 
> 2. On resume from suspend (S3), I had to reboot my machine - in 
> kern.log, I found the message sequence listed below
> 
> 3.
> 
> 4. Kernel version:  Linux version 2.6.26-1-686-bigmem (Debian 2.6.26-8) 
> (waldi@debian.org) (gcc version 4.1.3 20080623 (prerelease) (Debian 
> 4.1.2-23)) #1 SMP Thu Oct 9 16:07:43 UTC 2008
> 
> 5. kern.log messages concerning the problem:
> Nov 23 08:43:11 orion kernel: [72021.370670] BUG: unable to handle 
> kernel NULL pointer dereference at 00000002
> Nov 23 08:43:11 orion kernel: [72021.370674] IP: [<c018caab>] 
> __d_lookup+0xb9/0xd7
> Nov 23 08:43:11 orion kernel: [72021.370680] *pdpt = 0000000032005001 
> *pde = 0000000000000000
> Nov 23 08:43:11 orion kernel: [72021.370684] Oops: 0000 [#1] SMP
> Nov 23 08:43:11 orion kernel: [72021.370687] Modules linked in: nls_utf8 
> isofs zlib_inflate udf nls_base crc_itu_t tcp_diag inet_diag usblp vmnet 
> vmblock v
> mci vmmon fglrx(P) binfmt_misc ppdev lp video output ac battery 

Does this still happen without the proprietary fglrx module loaded?

