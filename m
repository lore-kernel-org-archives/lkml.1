Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYKRXpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYKRXpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYKRXpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:45:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYKRXp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:45:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       heukelum@fastmail.fm, Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
In-Reply-To: Andi Kleen's message of  Wednesday, 19 November 2008 00:35:52 +0100 <20081118233552.GP6703@one.firstfloor.org>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
	<20081117175232.GA13766@mailshack.com>
	<49228648.76E4.0078.0@novell.com>
	<20081118111633.GA21036@mailshack.com>
	<4922C863.76E4.0078.0@novell.com>
	<20081118140349.GC23479@elte.hu>
	<4922E4D4.76E4.0078.0@novell.com>
	<20081118150024.GD30358@elte.hu>
	<20081118225336.60FFA1544EB@magilla.localdomain>
	<20081118233552.GP6703@one.firstfloor.org>
X-Zippy-Says: Here we are in America...  when do we collect unemployment?
Message-Id: <20081118234511.80C4F1544F1@magilla.localdomain>
Date: Tue, 18 Nov 2008 15:45:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I mean a single macro that produces both the instruction and the CFI
pseudo-op to go with it.  This is the essential characteristic that makes
it an improvement for maintaining the code.  The main problem we have now
is that it's easy to write/modify plain assembly instructions and forget to
add or update the CFI to match.  A well-considered set of macros can solve
this without making it any harder for the average assembly programmer to
understand what each line of the source means intuitively.


Thanks,
Roland
