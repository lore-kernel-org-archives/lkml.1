Return-Path: <linux-kernel-owner+w=401wt.eu-S935190AbXHHXP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935190AbXHHXP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbXHHXPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:15:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57794 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760168AbXHHXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:15:09 -0400
Date: Thu, 9 Aug 2007 00:18:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Ingo Molnar <mingo@elte.hu>,
       J??rn Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070809001831.46147921@the-village.bc.nu>
In-Reply-To: <46BA1C08.4050904@garzik.org>
References: <20070804191205.GA24723@lazybastard.org>
	<20070804192130.GA25346@elte.hu>
	<20070804211156.5f600d80@the-village.bc.nu>
	<20070804202830.GA4538@elte.hu>
	<20070804210351.GA9784@elte.hu>
	<20070804225121.5c7b66e0@the-village.bc.nu>
	<20070805073709.GA6325@elte.hu>
	<20070805134328.1a4474dd@the-village.bc.nu>
	<20070805125433.GA22060@elte.hu>
	<20070805143708.279f51f8@the-village.bc.nu>
	<20070805180826.GD3244@elte.hu>
	<46BA09CC.7070007@tmr.com>
	<46BA1C08.4050904@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007 15:39:52 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Bill Davidsen wrote:
> > Being standards compliant is not an argument it's a design goal, a 
> > requirement. Standards compliance is like pregant, you are or you're 
> 
> Linux history says different.  There was always the "final 1%" of 
> compliance that required silliness we really did not want to bother with.

This isn't about the 1% however. Its about API and ABI. Changing the
default is a fairly evil ABI change. Telling everyone relatime is cool on
desktops and defaulting it in the distro is not an ABI change and is very
sensible
