Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYD2Cdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYD2Cdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 22:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYD2Cd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 22:33:29 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:33009 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYD2Cd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 22:33:29 -0400
Date: Mon, 28 Apr 2008 22:32:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
Message-ID: <20080429023217.GA15676@c2.user-mode-linux.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153831.GC2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 05:41:11PM -0700, Linus Torvalds wrote:
> So just removing the inline is simply not acceptable any more, since it 
> just implies total and utter breakage of the compiler. At some point you 
> just have to say: "That is sh*t", and not take it any more.
> 
> What is UML doing to trigger this? 

Beats the crap out of me.  These things are very generic code from
UML's point of view.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
