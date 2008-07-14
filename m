Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYGNUuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYGNUuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYGNUtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:49:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461AbYGNUty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:49:54 -0400
Date: Mon, 14 Jul 2008 13:49:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
In-Reply-To: <20080714135034.GA7013@elte.hu>
Message-ID: <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org>
References: <20080714135034.GA7013@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Ingo Molnar wrote:
> 
> Please pull the latest x86 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/for-linus

Things like this _really_ irritate me:

	Memtest (MEMTEST) [Y/n/?] (NEW) ?

why the hell is that defaulting to "on"?

The rule of thumb should be:

	NO NEW FEATURES SHOULD _EVER_ DEFAULT TO 'ON'!

I do realize that developers always think that _their_ particular cool new 
feature is so important that it should default to 'on', but that's always 
the case, and it's _always_ wrong.

The only really acceptable reason to add a new config feature and make it 
default to 'y' is that it's actually an old feature that just didn't have 
a config option, so not defaulting to it will actually break peoples 
existing configurations.

If some distro wants to enable features by default for their users, that's 
their issue. But we should not do it for them.

		Linus
