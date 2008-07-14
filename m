Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYGNVBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYGNVBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbYGNVBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:01:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128AbYGNVBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:01:36 -0400
Date: Mon, 14 Jul 2008 14:01:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
In-Reply-To: <487BBDCB.7050303@zytor.com>
Message-ID: <alpine.LFD.1.10.0807141359450.3305@woody.linux-foundation.org>
References: <20080714135034.GA7013@elte.hu> <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org> <487BBDCB.7050303@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, H. Peter Anvin wrote:
> 
> I'm a bit surprised that you'd say that for something that is a
> hardware-testing feature that needs a command-line option to be enabled at
> runtime.  I have always presumed that the default value is the recommended
> value, and I would think that that is what most people would assume.

No. The default value should be 'off', unless it's _needed_ by people.

Have you guys looked at the size of the kernel lately?

Bloat is bloat. Just because it's conditional is not an excuse.

Having an in-kernel memory tester is in no way better than having an 
out-of-kernel one that you pick at grub boot time, so the claim that it's 
a "recommended" thing is likely bogus too. 

		Linus
