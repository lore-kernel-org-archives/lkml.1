Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYJaQ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYJaQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYJaQ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:58:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYJaQ67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:58:59 -0400
Date: Fri, 31 Oct 2008 09:58:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
In-Reply-To: <20081031105105.092ebad3@bike.lwn.net>
Message-ID: <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no> <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com> <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org> <20081031100040.1f0cf34f@bike.lwn.net> <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org> <20081031105105.092ebad3@bike.lwn.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Oct 2008, Jonathan Corbet wrote:
> 
> The system boots, and I get what appears to be a working eth0.  This
> machine mounts some NFS filesystems, though, and as soon as I try to do
> that, everything locks up.  I've come to expect NFS to be slow, but
> that exceeds my expectations somewhat.
> 
> Other things seem to work, so, maybe, the NFS thing is a totally
> different problem, don't know.

It certainly could also be that the network card is unhappy in its new 
location.

Can you do any reasonable testing at all without NFS? In particular, can 
you boot without NFS and test that the networking still works? 

Oh, and getting the old (2.6.27) and new (2.6.28-rc2+patch) /proc/iomem 
would be nice.

No hurry. 

		Linus
