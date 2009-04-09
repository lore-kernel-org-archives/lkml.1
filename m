Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbZDIU6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbZDIU6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZDIU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:58:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521AbZDIU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:58:10 -0400
Date: Thu, 9 Apr 2009 13:47:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] Make relatime default
In-Reply-To: <20090409194624.GB1403@ucw.cz>
Message-ID: <alpine.LFD.2.00.0904091343110.4583@localhost.localdomain>
References: <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
 <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain> <20090409194624.GB1403@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Pavel Machek wrote:
> 
> 'No changes of ABI in stable series?'

(a) we don't have a stable series any more
and
(b) this isn't an abi change, it's a system management change.

If you don't think we can make those, then I assume that you also claim 
that we can't do thigns like commit 1b5e62b42, which doubled the writeback 
dirty thresholds, or any of the things that changed how dirty accounting 
was done in the first place?

I would _love_ for distros to do the sane thing, but they don't. That's a 
fact.

			Linus
