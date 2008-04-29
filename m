Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbYD2BWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbYD2BWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYD2BWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:22:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbYD2BWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:22:12 -0400
Date: Mon, 28 Apr 2008 18:21:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
In-Reply-To: <20080429011202.GH5882@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0804281819480.3119@woody.linux-foundation.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
 <20080428153831.GC2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org> <20080429011202.GH5882@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Apr 2008, Al Viro wrote:
> 
> AFAICS, it's a gcc bug.

So did the "always_inline" thing just hide this? Or what is going on?

We can just say that gcc-3 has to always_inline if so.

			Linus
