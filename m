Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYKQTtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYKQTtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYKQTtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:49:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbYKQTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:49:15 -0500
Date: Mon, 17 Nov 2008 11:48:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081117.112157.146825192.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0811171147380.18283@nehalem.linux-foundation.org>
References: <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <20081117.112157.146825192.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, David Miller wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 17 Nov 2008 12:01:19 +0100
> 
> > The scheduler's overhead barely even registers on a 16-way x86 system 
> > i'm running tbench on. Here's the NMI profile during 64 threads tbench 
> > on a 16-way x86 box with an v2.6.28-rc5 kernel [config attached]:
> 
> Try a non-NMI profile.
> 
> It's the whole of the try_to_wake_up() path that's the problem.

David, that makes no sense. A NMI profile is going to be a _lot_ more 
accurate than a non-NMI one. Asking somebody to do a clearly inferior 
profile to get "better numbers" is insane.

We've asked _you_ to do NMI profiling, it shouldn't be the other way 
around.

		Linus
