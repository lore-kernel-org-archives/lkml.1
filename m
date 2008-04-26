Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYDZR52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYDZR52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYDZR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:57:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbYDZR5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:57:20 -0400
Date: Sat, 26 Apr 2008 10:56:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <20080426173513.GQ2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804261052550.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426112717.GA23248@uranus.ravnborg.org> <20080426144404.GG2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804260951190.2813@woody.linux-foundation.org>
 <20080426170950.GL2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261016050.2813@woody.linux-foundation.org> <20080426173513.GQ2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Adrian Bunk wrote:
> 
> Do you consider all patches that fix build errors as critical?
> If yes, only for x86 or for all architectures?

I think that things that hold up people testing a development kernel is 
"important". Maybe not "critical", but certainly stuff I should fix asap, 
just so that people who might otherwise test a kernel (but aren't 
technical enough to fix even possibly trivial errors) won't get 
discouraged.

And yes, x86(-64) is the one that matters a whole lot more for that kind 
of 'random tester' issue. If other architectures don't build in some 
random config, I don't consider that a huge deal, since anybody who builds 
a development kernel for (say) powerpc will also generally have the 
ability to fix whatever silly brown-paper-bug issue just as well as I 
could.

			Linus
