Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0AOUha (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258Ab0AOUh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:37:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:34457 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758256Ab0AOUhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:37:22 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX19gW1lW36FgyyR9a0sjYDnh3pOf9RjwTwfpEyVZqX
	bRJ4H5eg3Iaadb
Date: Fri, 15 Jan 2010 22:40:39 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: Arjan van de Ven <arjan@infradead.org>, Alex Chiang <achiang@hp.com>,
        Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: -O0 kernel Re: High cpu temperature with 2.6.32, bisection shows
 commit 69d258 (fwd)
In-Reply-To: <20100115195811.GB1345@ucw.cz>
Message-ID: <alpine.LNX.2.00.1001152227360.2311@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain> <20100108171513.GB22713@ldl.fc.hp.com> <20100109134352.3dedd4ea@infradead.org> <alpine.LNX.2.00.1001100155370.1325@localhost.localdomain> <20100109160836.26a344a9@infradead.org>
 <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain> <20100115195811.GB1345@ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Pavel Machek wrote:
>
>> BTW, how can I remove that irritating -O2 flag? I 'm used to compiling
>> with -O0 my debug builds in userland, because compilation is *many times*
>> faster. I should be really useful for bisections.
>
> Actually, figuring out kernel flags for fastest kernel compilation
> would be nice. Nice for bisect, and nice for slow machines. Zaurus
> needs 4 hours to compile kernel, kohjinsha cca 1.5 hours.
>
> -O0 may not fly, as inlining is needed... some tests are

I did some research too and this has been discussed again. Regarding 
inlining and -O0 I understand that theoretically it should work, but 
practically it doesn't. Here is an explanatory message from Andi Kleen:

http://lists.openwall.net/linux-kernel/2008/09/09/399

> neccessary. Now that we support icc, gcc -O0 should be doable, too...
>
> ...ok, so I tried -O0.
>
> -O2 compilation took 1250seconds, -O0 took 1167seconds and failed.
>
> is there some fast compiler around that could be used?

Strange that -O0 was not faster. Compiling userland I'm sure I've seen 
great speeds, and much less memory usage. Another compiler that is 
infamous for its speed is TCC (Tiny C Compiler) but I haven't actually 
used it, perhaps you want to try first. :-)


Dimitris

