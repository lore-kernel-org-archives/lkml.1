Return-Path: <linux-kernel-owner+w=401wt.eu-S966286AbXJSGsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966286AbXJSGsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXJSGsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:48:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43512 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbXJSGsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:48:45 -0400
Date: Fri, 19 Oct 2007 08:48:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
Subject: Re: libata crash
Message-ID: <20071019064817.GA23000@elte.hu>
References: <20071018164745.GD10674@kernel.dk> <20071018192839.GA17247@elte.hu> <20071018193236.GJ10674@kernel.dk> <20071018195903.GA29567@elte.hu> <20071018204111.GN10674@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018204111.GN10674@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > and make sure it builds:
> > 
> > drivers/scsi/fd_mcs.c: In function 'fd_mcs_intr':
> > drivers/scsi/fd_mcs.c:976: error: 'struct scatterlist' has no member named 'page'
> > drivers/scsi/fd_mcs.c:1009: error: 'struct scatterlist' has no member named 'page'
> > drivers/scsi/fd_mcs.c: In function 'fd_mcs_queue':
> > drivers/scsi/fd_mcs.c:1112: error: 'struct scatterlist' has no member named 'page'
> > drivers/scsi/in2000.c: In function 'in2000_queuecommand':
> > drivers/scsi/in2000.c:375: error: 'struct scatterlist' has no member named 'page'
> > drivers/scsi/in2000.c: In function 'transfer_bytes':
> > drivers/scsi/in2000.c:767: error: 'struct scatterlist' has no member named 'page'
> 
> Oops, wonder why they were missed in the allyes/modconfig. Fixed now, 
> thanks!

where can i pick the latest sg patchset up from? These build failures 
are ruining my make randconfig build tests :)

	Ingo
