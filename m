Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbZCZU77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbZCZU77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbZCZU7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:59:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56229 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756520AbZCZU7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:59:49 -0400
Date: Thu, 26 Mar 2009 20:58:41 +0000
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
Message-ID: <20090326205841.16e1bab3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326205534.GA11217@srcf.ucam.org>
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
	<20090326205534.GA11217@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree, but arguing for something on the basis of a spec isn't terribly 
> convincing if the spec allows effectively identical behaviour. SuS isn't 
> a relevant consideration when it comes to deciding default atime policy.

I'd says its or minor relevance. The default expected behaviour we had
last week is however of major relevance and that is my big concern.
