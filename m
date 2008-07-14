Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYGNVZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYGNVZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbYGNVZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:25:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756071AbYGNVZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:25:41 -0400
Date: Mon, 14 Jul 2008 14:25:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
In-Reply-To: <alpine.LFD.1.10.0807141359450.3305@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807141422200.14679@woody.linux-foundation.org>
References: <20080714135034.GA7013@elte.hu> <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org> <487BBDCB.7050303@zytor.com> <alpine.LFD.1.10.0807141359450.3305@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Linus Torvalds wrote:
> 
> Bloat is bloat. Just because it's conditional is not an excuse.

Btw, the reason I reacted was that that wasn't even the only one.

It was followed by that MTRR "cleanup" question, which also defaulted to 
'y', despite:

 - having a help message that warned about oopses and problems

 - answering 'y' then caused a follow-up of totally incomprehensible and 
   meaningless options with no help message what-so-ever.

Dammit, if _I_ find the option to be badly named, confusing, unnecessary 
and undocumented, maybe it should be a clue to somebody that it probably 
shouldn't exist, much less default to 'sure, do that crazy thing'.

(I think there was something else, but by then I didn't care any more, and 
just said no without even looking at the insane crap)

			Linus
