Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZCZSxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZCZSxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZCZSxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:53:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47393 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752879AbZCZSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:53:43 -0400
Date: Thu, 26 Mar 2009 18:52:43 +0000
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
Subject: Re: [PATCH 1/2] Add a strictatime mount option
Message-ID: <20090326185243.5bf44458@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326174956.GB7198@srcf.ucam.org>
References: <20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	<20090326170714.GF6239@mit.edu>
	<alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
	<20090326174956.GB7198@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 17:49:56 +0000
Matthew Garrett <mjg@redhat.com> wrote:

> Add support for explicitly requesting full atime updates. This makes it
> possible for kernels to default to relatime but still allow userspace to
> override it.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

NAK this is unneccessary complication from a broken ABI change that isn't
safe to make anyway.

