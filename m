Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYKDU06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYKDU06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYKDU0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:26:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYKDU0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:26:49 -0500
Message-ID: <4910AFE5.4020408@zytor.com>
Date: Tue, 04 Nov 2008 12:26:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <491090F3.5020701@zytor.com> <1225824256.28612.1282966677@webmail.messagingengine.com> <4910A390.409@zytor.com> <20081104203046.GF29626@one.firstfloor.org>
In-Reply-To: <20081104203046.GF29626@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Or again just generate them on demand when the interrupt is set up.
> If you really have 240 interrupts sources you can afford the 5k likely,
> but for most there will be only a minimum number of stubs.
> 
> Although frankly I suspect there are far easier ways to save 5k of memory.
> 

Generating them dynamically is probably pretty ugly too, though.

Shrinking the whole table down to 2K by just regularizing the structure
is trivial, though, and should almost certainly be a win.  The more
esoteric ideas are probably worse.

	-hpa
