Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbXJVXUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbXJVXUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXJVXT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:19:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXJVXT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:19:58 -0400
Date: Tue, 23 Oct 2007 01:19:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, WANG Cong <xiyou.wangcong@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022231927.GA30814@elte.hu>
References: <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking> <20071022124322.GB8181@ftp.linux.org.uk> <20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471D2ECC.6090209@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > we should kill it there too.
> >
> > the only place where we should _please_ keep those annotations are for 
> > functions that get called from assembly code. This makes life immensely 
> > easier for -pg (CONFIG_FUNCTION_TRACING) kernels.
> 
> Should we re-add them for the function pointers in asm-x86/paravirt.h?

yes, yes, yes. :-) It was a nightmare to sort it out in -rt (and still 
is). It's also good documentation - it pinpoints functions that are 
called from assembly.

> Andi argued we should remove them since x86 is unconditionally regparm 
> now anyway - and they're pretty ugly syntactically.

Sure, it doesnt make things prettier, but i didnt see any particular 
ugliness.

	Ingo
