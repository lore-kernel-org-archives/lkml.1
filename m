Return-Path: <linux-kernel-owner+w=401wt.eu-S1761858AbZCZU4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761858AbZCZU4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbZCZU4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:56:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47165 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbZCZU4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:56:06 -0400
Date: Thu, 26 Mar 2009 20:55:34 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
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
Message-ID: <20090326205534.GA11217@srcf.ucam.org>
References: <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326185900.166a1097@lxorguk.ukuu.org.uk> <20090326200258.GA10313@srcf.ucam.org> <20090326204209.1da6e791@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326204209.1da6e791@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 08:42:09PM +0000, Alan Cox wrote:
> > before performing the update. So while relatime doesn't conform, the 
> > practical difference is meaningless. You can't depend on atime being 
> > updated in a timely manner.
> 
> POSIX says a disk write interrupted by a signal can be a short write. If
> you do this in practice all hell breaks loose.
> 
> A conforming implementation needs to conform with expectations not just
> play lawyer games with users systems.

I agree, but arguing for something on the basis of a spec isn't terribly 
convincing if the spec allows effectively identical behaviour. SuS isn't 
a relevant consideration when it comes to deciding default atime policy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
