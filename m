Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZCZUo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZCZUo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZCZUos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:44:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35179 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752222AbZCZUor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:44:47 -0400
Date: Thu, 26 Mar 2009 20:42:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326204209.1da6e791@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326200258.GA10313@srcf.ucam.org>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	<20090326170714.GF6239@mit.edu>
	<alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
	<20090326185900.166a1097@lxorguk.ukuu.org.uk>
	<20090326200258.GA10313@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> before performing the update. So while relatime doesn't conform, the 
> practical difference is meaningless. You can't depend on atime being 
> updated in a timely manner.

POSIX says a disk write interrupted by a signal can be a short write. If
you do this in practice all hell breaks loose.

A conforming implementation needs to conform with expectations not just
play lawyer games with users systems.

Alan
