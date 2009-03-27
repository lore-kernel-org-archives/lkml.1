Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZC0J0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZC0J0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZC0J0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:26:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56992 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZC0J0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:26:15 -0400
Date: Fri, 27 Mar 2009 10:26:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       adobriyan@gmail.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/kmemtrace] fs.h: uninline simple_transaction_set()
Message-ID: <20090327092601.GA8234@elte.hu>
References: <1237898630.25315.83.camel@penberg-laptop> <tip-44eea45ca9e25d6dd660d4806ef4c11209609e03@git.kernel.org> <20090326154840.GR28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326154840.GR28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Mar 25, 2009 at 04:51:28PM +0000, Ingo Molnar wrote:
> > Commit-ID:  44eea45ca9e25d6dd660d4806ef4c11209609e03
> > Gitweb:     http://git.kernel.org/tip/44eea45ca9e25d6dd660d4806ef4c11209609e03
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Wed, 25 Mar 2009 16:48:35 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 25 Mar 2009 17:48:14 +0100
> > 
> > fs.h: uninline simple_transaction_set()
> > 
> > Move simple_transaction_set() to the other simple-transaction
> > file helpers in fs/libfs.c.
> > 
> > This removes an implicit asm/page.h PAGE_SIZE dependency from
> > fs.h (asm/page.h is not an exported header so HEADERS_CHECK fils),
> > and also reduces kernel size a bit.
> 
> *shrug*

Thanks for the encouragement - it must be a lot of fun for you to 
work with other people and you seem to be taking great pride in 
seeing improvements to the code you maintain and care about, no 
matter how insignificant they seem in isolation ;-)

> I can live with that.  Which tree do you want that to go through?  
> I'll be pushing VFS queue tonight.

Either way is certainly fine with me, you are the maintainer so it's 
your call. I kept the branch isolated and can adopt.

Note: the patch i sent has some (very minimal) dependencies on a 
previous patchlet [which adds the asm/page.h include to fs.h - that 
dependency was implicit before], it will be all just fine if you 
ignore the fs.h reject when you apply the patch.

Thanks,

	Ingo
