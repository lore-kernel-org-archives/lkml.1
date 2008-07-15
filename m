Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYGOEeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYGOEeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYGOEeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:34:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYGOEeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:34:12 -0400
Date: Mon, 14 Jul 2008 21:33:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
In-Reply-To: <20080715025149.GA6137@redhat.com>
Message-ID: <alpine.LFD.1.10.0807142126300.3017@woody.linux-foundation.org>
References: <20080714135034.GA7013@elte.hu> <20080715025149.GA6137@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Dave Jones wrote:
> 
> 6924d1ab8b7bbe5ab416713f5701b3316b2df85b is a work of art.
> Is it ascii-art tetris? a magic eye picture? you decide!
> 
> It looks even more spectacular in gitk.

Here's how to search for those with git:

	git rev-list --all --parents | egrep '( .*){10}' | cut -d' ' -f1

will show you all commits with ten or more parents (although some of them 
have duplicate parents due to git historically not checking that very 
carefully).

Len and rmk have been doing it for a while, but yeah, I think Ingo pushed 
the envelope there a bit.

But 96916090f488986a4ebb8e9ffa6a3b50881d5ccd is pretty nice too, doncha 
think?

		Linus
