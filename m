Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYKRX0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYKRX0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYKRX0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:26:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56664 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYKRX0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:26:09 -0500
Date: Wed, 19 Nov 2008 00:35:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       heukelum@fastmail.fm, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
Message-ID: <20081118233552.GP6703@one.firstfloor.org>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com> <20081118111633.GA21036@mailshack.com> <4922C863.76E4.0078.0@novell.com> <20081118140349.GC23479@elte.hu> <4922E4D4.76E4.0078.0@novell.com> <20081118150024.GD30358@elte.hu> <20081118225336.60FFA1544EB@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118225336.60FFA1544EB@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think auto-generation is very a useful angle to take for this any
> time soon.  Explicit (but simple) macros in the assembly is what I favor.

Do you mean macros that generate both the instruction and the CFI
or separate? The major disadvantage of doing it together in a 
single macro is that it is not really readable for any assembler 
programmer anymore, but starts becoming a Linux specific assembler 
language. Likely not a good thing for maintenance. anyone who
wants to know the real assembler would need to read objdump -S
output, which is not nice.

Perhaps it would be a reasonable readability improvement to just use shorter 
cfi macros which are not shouted?

-Andi
