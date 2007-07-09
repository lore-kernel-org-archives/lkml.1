Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXGINzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXGINzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXGINzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:55:45 -0400
Received: from gw.goop.org ([64.81.55.164]:60129 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbXGINzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:55:44 -0400
Message-ID: <46923E37.9010303@goop.org>
Date: Mon, 09 Jul 2007 06:55:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
References: <20070617214231.GA3588@stusta.de>	<46760D87.2000502@goop.org>	<20070708224444.GU3492@stusta.de>	<4691A196.7080305@goop.org> <20070709105123.1df728b2@the-village.bc.nu>
In-Reply-To: <20070709105123.1df728b2@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 2.6.22's behaviour is the bug. 2.6.21 you couldn't load random binary
> crap into the kernel without logging a taint. 2.6.22 you can. This means
> every single 2.6.22 bug report has to be assumed to be caused by binary
> module crap as a starting point which slows down debug immensely.

Er, what?  What do you mean by "load random binary crap"?  Are you 
worried that a malicious kernel module might modify paravirt_ops?  How 
is that different from a malicious module doing any of the infinite 
other things a malicious module can do?  A module will only register a 
taint if its playing by the rules anyway, and a module playing by the 
rules won't touch paravirt_ops directly.

    J

