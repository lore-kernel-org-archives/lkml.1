Return-Path: <linux-kernel-owner+w=401wt.eu-S1946077AbXBBVKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946077AbXBBVKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946080AbXBBVKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:10:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946077AbXBBVKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:10:06 -0500
Date: Fri, 2 Feb 2007 13:09:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <Pine.LNX.4.64.0702021244250.5219@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702021306090.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202195932.15b9b4ed@localhost.localdomain>
 <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702021244250.5219@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Feb 2007, Davide Libenzi wrote:
> 
> Actually, coroutines are not too bad to program once you have a 
> total-coverage async scheduler to run them.

No, no, I don't disagree at all. In fact, I agree emphatically.

It's just that you need the scheduler to run them, in order to not "see" 
them as coroutines. Then, you can program everything *as*if* it was just a 
regular declarative linear language with multiple threads).

And that gets us the same programming interface as we always have, and 
people can forget about the fact that in a very real sense, they are using 
coroutines with the scheduler just keeping track of it all for them.

After all, that's what we do between processes *anyway*. You can 
technically see the kernel as one big program that uses coroutines and the 
scheduler just keeping track of every coroutine instance. It's just that I 
doubt that any kernel programmer really thinks in those terms. You *think* 
in terms of "threads".

			Linus
