Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXJQTST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXJQTST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbXJQTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:18:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbXJQTSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:18:05 -0400
Date: Wed, 17 Oct 2007 21:17:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017191743.GA15870@elte.hu>
References: <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190422.GA12711@elte.hu> <20071017190821.GX15552@kernel.dk> <20071017191456.GA14916@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017191456.GA14916@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1650]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
> > > drivers/scsi/scsi_lib.c:708: note: 'index' was declared here
> > > 
> > > not sure it matters.
> > 
> > Hmm, I don't see them here (gcc 4.2.1). Must be the BUG(), does it go 
> > away if you add a index = -1 in the default: case? Just to be 
> > absolutely sure...
> 
> well if i initialize the variable then of course the warning goes away
> :)
> 
> NOTE: i get the same warning even without the BUG_ON() patch, and 
> without your other fix patch as well. I'm using gcc 4.2.2. (Do you get 
> the warning if you pick up the config i sent you earlier today?)

btw., i changed the initialization to -1 and the crash still occurs 
(as expected).

	Ingo
