Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbXK1Sh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbXK1Sh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbXK1ShS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:37:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXK1ShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:37:17 -0500
Date: Wed, 28 Nov 2007 19:37:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Dike <jdike@addtoit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128183706.GA3826@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128182935.GA8048@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jeff Dike <jdike@addtoit.com> wrote:

> On Wed, Nov 28, 2007 at 04:35:12PM +0100, Miklos Szeredi wrote:
> > Something like:
> > 
> >   dd if=/host/tmp/bigfile of=/tmp/bigfile bs=1048576 count=100
> > 
> > and run 'top' or 'watch something' in another terminal, which
> > sometimes completely stops updating during the write.
> 
> Are you talking about missing updates for a few seconds, or for 
> longer?  With the common above, with top -delay 1, and with 600M of 
> data, I'm seeing occasional 2-3 pauses, with one missing 5 seconds.

even sub-second delays are a huge issue if the system is otherwise idle 
- it signals some sort of missed event condition. scheduling must be 
instantenous.

	Ingo
