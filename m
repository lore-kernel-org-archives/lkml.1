Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYKDUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYKDUWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYKDUWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:22:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55667 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYKDUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:22:15 -0500
Date: Tue, 4 Nov 2008 21:30:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104203046.GF29626@one.firstfloor.org>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <491090F3.5020701@zytor.com> <1225824256.28612.1282966677@webmail.messagingengine.com> <4910A390.409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4910A390.409@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fixing the first of these I think is a no-brainer.  That will cut the
> size of the existing stub pool by almost half.  The second is more of a
> judgement call, and I'd like to see performance numbers for it.  Either
> which way, I think it's worthwhile to consider this as an alternative to
>   playing segmentation tricks, which I think could have really nasty
> side effects.

Or again just generate them on demand when the interrupt is set up.
If you really have 240 interrupts sources you can afford the 5k likely,
but for most there will be only a minimum number of stubs.

Although frankly I suspect there are far easier ways to save 5k of memory.

-Andi
