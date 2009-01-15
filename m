Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbZAOIvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbZAOIvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZAOIvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:51:47 -0500
Received: from cs-studio.ru ([195.178.208.66]:34849 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZAOIvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:51:46 -0500
Date: Thu, 15 Jan 2009 11:51:44 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Bryan Donlan <bdonlan@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Matthias Andree <matthias.andree@gmx.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [take3] OOM documentation update [was: Linux killed Kenny, bastard!]
Message-ID: <20090115085144.GC29586@ioremap.net>
References: <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com> <20090113213316.GB27227@ioremap.net> <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com> <20090114161225.GA9584@ioremap.net> <20090114170606.GB12102@ioremap.net> <3e8340490901141353u3990148ft1b20220a8317f7dc@mail.gmail.com> <20090114221420.GB6039@ioremap.net> <alpine.DEB.2.00.0901141655390.22699@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901141655390.22699@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:58:41PM -0800, David Rientjes (rientjes@google.com) wrote:
> > +
> > +The task with the highest badness score is then killed.
> > +
> 
> Not quite, even after a task is selected for oom kill, the oom killer 
> still prefers to kill one of its children first if any have a different 
> mm.  See oom_kill_process().

Ok, if it was not clear from the description.

> You also don't mention the exception of OOM_DISABLE (oom_adj score of -17) 
> in your formula for how oom_adj impacts the points value.  Although its 
> already explained earlier, it should be mentioned here since a oom_adj is 
> an int and a right shift of 17 does not guarantee `points' will be 0.

It is written several lines above.

-- 
	Evgeniy Polyakov
