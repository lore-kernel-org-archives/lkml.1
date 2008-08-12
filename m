Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYHLWU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYHLWU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHLWUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:20:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbYHLWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:20:48 -0400
Date: Tue, 12 Aug 2008 15:20:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080812224730.0e668dee@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808121516180.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <87proe81c1.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
 <20080812224730.0e668dee@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Aug 2008, Alan Cox wrote:
> 
> That said there is nothing that says we can't have a 'posix_me_harder'
> sysfs control for such things. The standards say what should occur in the
> normal situation not what should occur if you intentionally move out of
> the standard definition.

Yeah. That said, I doubt it's a very common problem in practice. I'm 
pretty sure nobody really cares, and almost nobody really wants to run 
really old binaries. So it's almost certainly not worth it (and the one 
time I had it happen, I didn't bother to do it right, I just hacked around 
it and obviously never committed the hack).

I just find it a bit sad how well we actually _can_ run old binaries, but 
sometimes there are these new things that were literally designed to break 
them.

Of course, the much more common breakage comes from not having access to 
old shared libraries etc totally user-space issues. The few kernel cases 
of EOVERFLOW are totally hidden by just distro differences over time. If 
the binary I had hadn't been statically linked, I wouldn't have had a 
chance, I suspect.

(Of course, static linking wasn't exactly unusual for really old binaries)

			Linus
