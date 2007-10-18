Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbXJRKtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbXJRKtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbXJRKtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:49:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbXJRKti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:49:38 -0400
Date: Thu, 18 Oct 2007 12:49:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018104910.GA9658@elte.hu>
References: <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk> <20071018101348.GA29296@elte.hu> <20071018101650.GR5063@kernel.dk> <20071018101739.GS5063@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018101739.GS5063@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > It would always be nice. For this case I don't think it's very 
> > interesting, if we pursue the improved sg iteration setup.
> 
> BTW, I think it's pretty clear that ata_sg_is_last() is broken. It's 
> likely a one-off in the n_iter test.

fixing that would be a -stable candidate, as a potential data corruptor 
- or is it more benign?

	Ingo
