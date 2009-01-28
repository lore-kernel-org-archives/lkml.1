Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZA1V0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZA1V0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZA1VZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:25:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZA1VZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:25:58 -0500
Message-ID: <4980CD51.70601@zytor.com>
Date: Wed, 28 Jan 2009 13:25:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
References: <20090127222825.GA27097@elte.hu>	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>	 <1233106614.3256.6.camel@localhost.localdomain>	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>	 <1233170532.6717.49.camel@brick>	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain> <1233172994.6717.56.camel@brick>
In-Reply-To: <1233172994.6717.56.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> For now, the problem is with arches like X86 that need to test the availability of
> an instruction.  So the arch versions could be unconditionally offered on X86_64
> and the lowest-common denominator (no BSWAP) on X86-32.  If we still want the
> optimized (BSWAP) versions on X86-32 the tests will have to use the compiler arch flags
> as opposed to CONFIG_BSWAP....which is probably not worth the trouble.
> 

Well, that's how the headers were originally written, I believe.

CONFIG_BSWAP can be replaced with the __i486__ macro, and since most 
distros compile for i586 or i686 these days, it might actually make 
sense for this one particular case.

	-hpa

