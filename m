Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbZC0LYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbZC0LYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZC0LXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:23:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50945 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbZC0LXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:23:50 -0400
Date: Fri, 27 Mar 2009 11:22:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090327112248.2746a4ba@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326230435.GA10884@brong.net>
References: <20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	<20090326170714.GF6239@mit.edu>
	<alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
	<20090326185900.166a1097@lxorguk.ukuu.org.uk>
	<20090326200258.GA10313@srcf.ucam.org>
	<20090326204209.1da6e791@lxorguk.ukuu.org.uk>
	<20090326230435.GA10884@brong.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this the same Alan Cox who thought a couple of months ago that
> having an insanely low default maximum number epoll instances was a
> reasonable answer to a theoretical DoS risk, despite it breaking
> pretty much every reasonable user of the epoll interface?

In the short term yes - because security has to be a very high priority.
Lesser of two evils.

Alan
