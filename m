Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbYJOQCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbYJOQCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYJOQCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:02:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYJOQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:02:23 -0400
Date: Wed, 15 Oct 2008 09:01:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: GIT head no longer boots on x86-64
In-Reply-To: <48F60D56.6040209@gmail.com>
Message-ID: <alpine.LFD.2.00.0810150859410.3288@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org> <1223910693-28693-1-git-send-email-jirislaby@gmail.com> <20081013164717.7a21084a@lxorguk.ukuu.org.uk> <20081015115153.GA16413@elte.hu> <alpine.LFD.2.00.0810150758310.3288@nehalem.linux-foundation.org>
 <48F60D56.6040209@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Jiri Slaby wrote:
> 
> Users usually do
> is_vmalloc_addr(a) ? vfree(a) : kfree(a);
> Even there it makes more sense to me.

Umm. No it doesn't.

That is exactly _wh7y_ "is_vmalloc_addr()" exists. But we sure as hell 
don't ever want to trigger on modules for that.

If you think that "is_vmalloc_addr()" should trigger for any kernel 
virtual address, why not just make it do so, then? And _name_ it so.

Names are important. In fact, naming is often _more_ important than the 
implementation is. And that means that the implementation should follow 
the naming, or the implementation is wrong.

			Linus
