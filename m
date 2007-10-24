Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbXJXREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbXJXREt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765130AbXJXQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:59:35 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48102 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761960AbXJXQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:59:34 -0400
Date: Wed, 24 Oct 2007 19:00:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make kernel/sched.c:account_guest_time() static
Message-ID: <20071024170001.GA30533@stusta.de>
References: <20071024162517.GW30533@stusta.de> <20071024165027.GA32682@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071024165027.GA32682@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 06:50:27PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > account_guest_time() can become static.
> 
> thanks, applied.
> 
> btw., how about adding your 'check static functions' scripts to the 
> kernel, via a "make checkstatic" pass or something like that? That way 
> people could check this for themselves and could avoid letting them into 
> the kernel.

It is not my script, it was written by Keith Owens.

It is already available as "make namespacecheck" since kernel 2.6.9.

And yes, it is already documented besides checkstack in
Documentation/SubmitChecklist point 10.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

