Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYBRKQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYBRKQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYBRKQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:16:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:33198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbYBRKQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:16:46 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
Date: Mon, 18 Feb 2008 11:16:42 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <andyw@uk.ibm.com>
References: <20080215165244.GA28358@elte.hu> <200802151815.44050.ak@suse.de> <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181116.42824.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> People, who do cleanups - I'm not talking about running lindent here -
> read through the code while they fix it up.

Please feel free to repeat my little experiment: give someone who sends
you a lot of checkpatch.pl only patches a simple task that actually
requires a little actual code change and at least a little localized 
understanding of code. See how well they do.

In my case it was the "turn ->ioctl into ->unlocked_ioctl" task,
which was simple enough.

I found that there were a lot of useful unlocked_ioctl patches
in the end, but they all only came from people who hadn't submitted
any checkpatch.pl only patches before.

-Andi



