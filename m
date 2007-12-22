Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXLVUhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXLVUhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXLVUhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:37:03 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39110 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbXLVUhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:37:01 -0500
Message-ID: <476D756A.6060507@davidnewall.com>
Date: Sun, 23 Dec 2007 07:06:58 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Richard D <richard@embunus.com>,
       "'Matthew Bloch'" <matthew@bytemark.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz> <476D35F6.90900@davidnewall.com> <20071222184759.GB31809@elf.ucw.cz>
In-Reply-To: <20071222184759.GB31809@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> memtest has following problems:
>
> 	0) it is kind of hard to run memtest over ssh
>   

It's kind of hard to run anything over SSH if it has to be run before 
userspace is up.  But the kernel can collect results from a modified 
memtest, after it chains back.

> 	1) if linux fixes some problem with PCI quirk or microcode
> 	upload, memtest will not see the fix
>   

What are you saying?  Linux is going to fix faulty RAM?  The point with 
testing RAM is you *want* to see it fail; you don't want Linux to fix it.

> 	2) if memory only fails while something else happens (DMA to
> 	other piece of memory? Hard disk load glitching powre
> 	supply?), memtest will not see the problem.

These are not RAM faults.  The very last thing you want is evidence that 
you've got a faulty piece of RAM when the fault is actually a hard disk 
glitch!
