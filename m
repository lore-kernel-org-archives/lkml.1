Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZKTShO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZKTShO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZKTShN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:37:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32900 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbZKTShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:37:12 -0500
Date: Fri, 20 Nov 2009 19:37:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
Message-ID: <20091120183708.GA1434@ucw.cz>
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com> <20091113095350.GC1364@elte.hu> <alpine.DEB.2.00.0911130158390.13911@chino.kir.corp.google.com> <20091113101326.GA17451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113101326.GA17451@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> There's two problems outlined in this discussion:
> 
>  A) too verbose bootup that is annoying with 64 CPUs and a show-stopper
>     with 4096 CPUs.
> 
>  B) the ad-hoc nature of our topology enumeration. Some of it is in
>     /sys, some of it is in printk logs. None really works well and 
>     there's no structure in it.
> 
> The simplest solution for (A) is what i suggested a few mails ago: dont 
> print the information by default, but allow (for trouble-shooting) 
> purposes for it to be printed when a boot option is passed.

Well, yes, it is *simplest*, but is it best? Example printing 'cpus
0-31 stepping 3, cpus 32-63 stepping 4' seem rather convincing --such
info should be there by default and not after speciial option...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
