Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYKWTuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYKWTuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYKWTtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:49:55 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:54886 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYKWTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:49:54 -0500
Date: Sun, 23 Nov 2008 20:51:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers to catch unbalanced declaration
Message-ID: <20081123195116.GA939@uranus.ravnborg.org>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost> <20081123185417.GA21106@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123185417.GA21106@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 07:54:17PM +0100, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > [Sam Ravnborg - Sun, Nov 23, 2008 at 07:12:48PM +0100]
> > ...
> > | > 
> > | > I don't have -next tree on my laptop, neither cross-compile tools but
> > | > if someone could test it -- it would be great. But I used gas macros
> > | > here -- i doubt other architectures has the same syntax. At least
> > | > PDP-11 would beat us with ';' symbol :)
> > | 
> > | If we include this in any of the 100+ trees that Stephen sucks
> > | into -next we will get it tried out.
> > | 
> > | Ingo has so and so does others so getting it into -next
> > | is rather easy. Then the automated builds will tell of if
> > | it fails on any of the toolchains used there.
> > | 
> > | 	Sam
> > | 
> > 
> > Sam, to be clear, you mean that I could put this stuff into general 
> > include/linux/linkage.h with general names as ENTRY/END and the same 
> > for KPROBE so it could be merged into -next tree for testing? If 
> > yes, that as I said there will be a lot of errors so build will 
> > stuck in a moment 'cause of unbalanced ENTRY. Not sure if it's a 
> > good idea :)
> 
> neither do i think it's a particularly good idea. Lets first prototype 
> it on x86, see how it works out in practice, and then see whether it 
> can be generic. Then it can just be lifted into the generic linkage.h 
> separately, and we can then see whether it causes new problems. 

OK - I assume you guys will take action on this if we succeed in x86
with this nice build time check.

	Sam
