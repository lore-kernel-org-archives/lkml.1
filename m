Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbYBJQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbYBJQqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 11:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYBJQqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 11:46:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbYBJQqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 11:46:34 -0500
Date: Sun, 10 Feb 2008 17:46:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210164624.GB7088@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210124629.GA12200@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210124629.GA12200@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> if (hex_val < 0)
> 	break;
> *long_val = (*long_val << 4) | hex_val;
> num++;
> (*ptr)++;

agreed, fixed.

> > +	remcom_out_buffer[0] = 'S';
> > +	remcom_out_buffer[1] = hexchars[ks->signo >> 4];
> > +	remcom_out_buffer[2] = hexchars[ks->signo % 16];
> use pack_hex_byte or & 0xf

fixed.

	Ingo
