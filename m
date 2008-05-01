Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYEAEra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYEAEra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYEAErV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:47:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYEAErV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:47:21 -0400
Date: Wed, 30 Apr 2008 21:46:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Paul Mackerras <paulus@samba.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <48194464.2000406@garzik.org>
Message-ID: <alpine.LFD.1.10.0804302142570.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <18457.219.995207.136771@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0804302034180.5994@woody.linux-foundation.org>
 <48194464.2000406@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Jeff Garzik wrote:
> 
> linux-next is _supposed_ to be solely the stuff that is ready to be sent to
> you upon window-open.

Yes, the "stuff" may be supposed to be stable. But the trees feeding it 
certainly are not. People are rebasing them etc, and it doesn't matter 
because I think linux-next starts largely from scratch next time around.

> So, I think a 'next' branch from you would open cans o worms:
> 
> - one more tree to test, and judging from linux-next and -mm it's tough to get
> developers to test more than just upstream
> 
> - is the value of holy penguin pee great enough to overcome this
> another-tree-to-test obstacle?
> 
> - opens all the debates about running parallel branches, such as, would it be
> better to /branch/ for 2.6.X-rc, and then keep going full steam on the trunk?

I do agree. And maybe I should have made it clear that I think it's worth 
it to me only if it then means that the merge window can shrink.

If I'd have both a 'next' branch _and_ a full 2-week merge window, there's 
no upside.

Btw, it wouldn't be another tree to test, since it would presumaby be what 
'linux-next' starts out from - so it would purely be something that 
doesn't have the constant re-merging of the more wild-and-crazy 
'linux-next' tree.

			Linus
