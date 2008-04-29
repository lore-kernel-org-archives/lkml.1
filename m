Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYD2E5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYD2E5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYD2E5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:57:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59887 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYD2E5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:57:12 -0400
Date: Tue, 29 Apr 2008 06:57:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
Message-ID: <20080429045744.GA2262@uranus.ravnborg.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153831.GC2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org> <20080429023217.GA15676@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429023217.GA15676@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:32:17PM -0400, Jeff Dike wrote:
> On Mon, Apr 28, 2008 at 05:41:11PM -0700, Linus Torvalds wrote:
> > So just removing the inline is simply not acceptable any more, since it 
> > just implies total and utter breakage of the compiler. At some point you 
> > just have to say: "That is sh*t", and not take it any more.
> > 
> > What is UML doing to trigger this? 
> 
> Beats the crap out of me.  These things are very generic code from
> UML's point of view.

How does the preprocessed code look like around the definition
and the declaration + use of said function?

Try to do an:
make path/to/file.i

To see the preprocessed output.

Just in case we have some subtle things going on..

	Sam
