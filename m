Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbZJLOYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbZJLOYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbZJLOYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:24:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251AbZJLOYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:24:39 -0400
Date: Mon, 12 Oct 2009 16:23:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
	uart_close+0x2a/0x1e4
Message-ID: <20091012142351.GA4565@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <20091012091954.GA31171@elte.hu> <20091012092713.GA32647@elte.hu> <20091012112504.GA10002@elte.hu> <20091012124501.3c1ac94f@lxorguk.ukuu.org.uk> <20091012115549.GA13987@elte.hu> <20091012122245.GA22088@elte.hu> <20091012140646.17bce0df@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012140646.17bce0df@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000240
> > IP: [<ffffffff812ea215>] uart_close+0x24/0x1e5
> 
> Very odd indeed. Can you dump the value of
> 
> 	state (ie tty->driver_data)
> 
> 	and if state is non NULL
> 
> 	state->uart_port
> 
> in the crash case
> 
> and if state->uart_port is NULL then there is some head scratching
> required 

Mind sending a debug patch for all info you'd like to see? (The 
advantage of that would be that others who hit this failure can test the 
patch too. Plus it's easier for me to get precisely what you want.)

	Ingo
