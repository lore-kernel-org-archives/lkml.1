Return-Path: <linux-kernel-owner+w=401wt.eu-S938520AbZDJPN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938520AbZDJPN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764040AbZDJPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:13:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761939AbZDJPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:13:17 -0400
Date: Fri, 10 Apr 2009 08:06:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
In-Reply-To: <20090410023207.GA27788@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain>
References: <20090410023207.GA27788@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, Alexey Dobriyan wrote:
>
> This is to show how we see C/R and to provoke discussion on number of
> important issues (mounts, ...).

My only initial reaction is that I absolutely hate the naming (not to say 
I love the code - just to say that I didn't even look at it, because I got 
hung up on the name).

"cr"? It could be anything. I realize that to _you_ that is meaningful, 
but to somebody less specifically interested in checkpoint-restore 'cr' 
means 'carriage return' or just doesn't really say anything at all. 

That goes both for file naming (kernel/cr/xyzzy.c) and to a lesser degree 
for function naming too. I also don't think it makes sense to have 
something like kernel/cr/cr-x86_32.c or kernel/cr/cr-tty.c - maybe that is 
good right now, but I sure hope that the long-term goal is to have these 
things in the code that will need to change them when the code gets 
updated (ie arch/x86/kernel and drivers/char/)

			Linus
