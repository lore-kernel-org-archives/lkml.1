Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYG3Vrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYG3Vrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYG3Vrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:47:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbYG3Vrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:47:47 -0400
Date: Wed, 30 Jul 2008 14:44:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linuxfoundation.org, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc1: IP: iov_iter_advance+0x2e/0x90
In-Reply-To: <20080730213745.GA20546@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.10.0807301442130.3277@nehalem.linux-foundation.org>
References: <20080730195457.GA3517@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807301255560.3334@nehalem.linux-foundation.org> <20080730213745.GA20546@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Alexey Dobriyan wrote:
> > 
> > So does this (hacky, ugly) patch fix it for you?
> 
> You forgot "untested".

I'm trying to teach people to just take my patches for granted as being 
untested. I think there is more shock value when I actually claim one of 
my patches is actually _tested_, so I guess I'll just emphasize that part 
in case it ever happens (and ok, it did happen for the cpu_mask thing).

> And, yes, it helps.

Ok, I'll commit it as obvious, ugly as it may be. And hope that Nick or 
some other god of iov_iter will think about trying to make these things 
more reliable and easier to use.

		Linus
