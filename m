Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbYDOCmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbYDOCmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbYDOCmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:42:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759827AbYDOCmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:42:01 -0400
Date: Mon, 14 Apr 2008 19:41:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ftp.linux.org.uk>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] F_GETPATH implementation (rev 2)
In-Reply-To: <Pine.LNX.4.64.0804141700010.6238@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.1.00.0804141931070.2879@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804141700010.6238@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Apr 2008, Davide Libenzi wrote:
>
> This is a small patch to support BSD's F_GETPATH on Linux.
> IMO the simplicity of the patch and the portability advantages makes it 
> worth it. I'll leave to others to further comments it.

So, I'd like to know who (if anybody) really uses F_GETPATH. 

I think the patch is simple enough, and if there is a real program that is 
worth porting for which this actually matters, I don't really see any 
downsides. But I'd like to hear more about it, and I also wonder if others 
do it differently.

Also, are there any other interfaces that other OS's use for this, do you 
know? Would be good to know before/if we decide to support something like 
this..

		Linus
