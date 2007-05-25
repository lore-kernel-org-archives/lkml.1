Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbXEYRBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbXEYRBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXEYRBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:01:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46763 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176AbXEYRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:01:41 -0400
Date: Fri, 25 May 2007 18:03:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Newport <crn@netunix.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070525180304.2cc4dae0@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com>
	<46559B54.80106@googlemail.com>
	<Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
	<alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
	<20070524193740.GA6787@elte.hu>
	<alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
	<20070525101105.GA9268@elte.hu>
	<4656CE39.8050800@netunix.com>
	<alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Disk dumps etc are options at things like wall street. But look at the bug 
> reports, and ask yourself how many of them happen at Wall Street, and how 
> many of them would even be _relevant_ to somebody there? 

There is an additional factor - dumps contain data which variously is -
copyright third parties, protected by privacy laws, just personally
private, security sensitive (eg browser history) and so on.

The only reasons you can get dumps back in the hands of vendors is
because there are strong formal agreements controlling where they go and
what is done with them.

Diskdump (and even more so netdump) are useful in the hands of a
developer crashing their own box just like kgdb, but not in the the
normal and rational end user response of  "its broken, hit reset"

Alan
