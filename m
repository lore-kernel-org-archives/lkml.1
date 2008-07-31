Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYGaXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYGaXH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYGaXHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:07:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39199 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbYGaXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:07:18 -0400
Date: Thu, 31 Jul 2008 23:48:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080731234817.7d563c36@lxorguk.ukuu.org.uk>
In-Reply-To: <20080731221924.GD8563@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
	<488FA318.3040905@zytor.com>
	<20080729232951.GB11223@linux-os.sc.intel.com>
	<488FAB2B.7050405@zytor.com>
	<20080730100326.GA9683@elte.hu>
	<20080730182539.GA17140@elte.hu>
	<20080730234102.GF11223@linux-os.sc.intel.com>
	<20080731212915.GH2729@elte.hu>
	<20080731215808.GB8563@linux-os.sc.intel.com>
	<20080731221435.GS23938@one.firstfloor.org>
	<20080731221924.GD8563@linux-os.sc.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But thats not what I see with for ex with, w83627hf_wdt.c
> 
> Its done at the module_init time. (while I thought it should be
> really done when some user level app opens the device, probably
> its poorly written to take care if the kernel panics before starting userland.
> but kernel can even die before the watchdog driver load aswell ;-)

Various watchdogs fail to conform in assorted differing ways. Wim did
some patches to build a common watchdog library and I sent him a rework
of it a while ago. Once that is adopted this should all get cleaned up.
Right now Wim is a bit busy however.

Alan
