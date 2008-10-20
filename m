Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYJTRAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYJTRAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYJTQ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:59:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbYJTQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:59:35 -0400
Date: Mon, 20 Oct 2008 09:57:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
In-Reply-To: <48FCB694.40901@zytor.com>
Message-ID: <alpine.LFD.2.00.0810200957301.3518@nehalem.linux-foundation.org>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com> <20081018082209.GA24220@elte.hu>
 <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org> <48FCB694.40901@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Oct 2008, H. Peter Anvin wrote:
> 
> Presumably it *should* be:
> 
> 	*((char *)to + 4) = *((char *)from + 4);

That's what it is in the kenrel. The "before and after" versions were both 
from broken Ingo code.

		Linus
