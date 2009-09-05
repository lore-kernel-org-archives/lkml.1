Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbZIEVYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbZIEVYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZIEVYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:24:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbZIEVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:24:41 -0400
Date: Sat, 5 Sep 2009 14:23:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Meelis Roos <mroos@linux.ee>
Subject: Re: [GIT PULL] percpu fixes for 2.6.31-rc8
In-Reply-To: <4A9D1A18.5000201@kernel.org>
Message-ID: <alpine.LFD.2.01.0909051422130.3414@localhost.localdomain>
References: <4A9D18B7.3010405@kernel.org> <4A9D1A18.5000201@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Sep 2009, Tejun Heo wrote:
> 
> Ummm... one question.  The above tree is on top of the previous
> for-linus fixes tree.  It pulls in to the current #master alright but
> it would still be a merge instead of a fast-forward.  Would it be
> better to prep fixes tree on top of the current #master so that it
> results in fast-forward?  If that's the case, please let me know or
> just cherry pick the top commit.

No, I actually prefer people to avoid rebasing unless they have some real 
reason for it. My pulls almost always end up being merges anyway, since I 
pull from several people, so even if you were to have rebased, it would 
_not_ have been a fast-forward for me, since I'd in the meantime have 
pulled from others anyway.

			Linus
