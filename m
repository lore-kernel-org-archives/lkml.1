Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbXHEAnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbXHEAnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 20:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbXHEAnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 20:43:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52425 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758797AbXHEAnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 20:43:24 -0400
Date: Sun, 5 Aug 2007 01:49:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Claudio Martins <ctpm@ist.utl.pt>
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805014926.400d0608@the-village.bc.nu>
In-Reply-To: <200708050051.40758.ctpm@ist.utl.pt>
References: <20070803123712.987126000@chello.nl>
	<46B4E161.9080100@garzik.org>
	<20070804224706.617500a0@the-village.bc.nu>
	<200708050051.40758.ctpm@ist.utl.pt>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  Can you give examples of backup solutions that rely on atime being updated?
> I can understand backup tools using mtime/ctime for incremental backups (like 
> tar + Amanda, etc), but I'm having trouble figuring out why someone would 
> want to use atime for that.

HSM is the usual one, and to a large extent probably why Unix originally
had atime. Basically migrating less used files away so as to keep the
system disks tidy.

Its not something usally found on desktop boxes so it doesn't in anyway
argue against the distribution using noatime or relative atime, but on
big server boxes it matters

