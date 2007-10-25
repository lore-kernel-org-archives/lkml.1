Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbXJYFbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbXJYFbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXJYFbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:31:37 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36654 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbXJYFbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:31:36 -0400
Message-ID: <47202A0F.4090807@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2007 11:00:55 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc1 doesn't build...
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071025051842.GC7094@thunk.org>
In-Reply-To: <20071025051842.GC7094@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> I can't seem to get 2.6.24-rc1 to build:
> 
>   ...
>   LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `smp_send_nmi_allbutself':
> /usr/projects/linux/linux-2.6/arch/x86/kernel/crash.c:85: undefined reference to `genapic'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Has anyone else seen this?
> 
> 						- Ted
Hi Ted,

The patch for this build issue is available at http://lkml.org/lkml/2007/10/24/128.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
