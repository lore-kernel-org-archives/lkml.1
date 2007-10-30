Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbXJ3UEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbXJ3UEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbXJ3UEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:04:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbXJ3UEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:04:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b1c6420f0710300740t5c708933x7ab1716c76504c57@mail.gmail.com>
References: <b1c6420f0710300740t5c708933x7ab1716c76504c57@mail.gmail.com> <20071029122759.2846.83510.stgit@warthog.procyon.org.uk> <20071029122809.2846.58795.stgit@warthog.procyon.org.uk>
To: "Suzuki Takashi" <suzuki.takashi@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] [PATCH 2/2] MN10300: Add the MN10300/AM33 architecture to the kernel [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 30 Oct 2007 20:04:05 +0000
Message-ID: <20112.1193774645@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Takashi <suzuki.takashi@gmail.com> wrote:

> Does this mean cpu-am33v3, cpu-am33v4, etc. will be created
> when a new core comes up?

Yes.  Note that the headers in a later one can 'inherit' from those of an
earlier one simply by #including that earlier one, much like archs do with
asm-generic headers.

> Isn't it possible to split codes by features, instead of target cores?

Perhaps, but I personally am not in a position to judge what features are
common to what CPUs.  I'll have to let someone from MEI answer that one.  I'll
discuss it with them.

> If similar codes were in multiple files and directories, it would be
> hard to maintain them.

#include is a wonderful thing.

> > +#ifdef CONFIG_MN10300_PROC_MN103E010
> > +       nop
> > +       nop
> > +       nop
> > +#endif
> 
> This should be conditioned by a feature.
> Isn't it a feature or a limitation that several non-FPU instructions are
> necessary just after the EPSW_FE is set?

Or it could just be a h/w bug in this particular processor.  I can always
patch it later to change the name.  Whatever it is, I suspect it will always
be controlled implicitly.

> Are these specific to MN103E010, or applicable to some other LSIs?

Yes.

> If they are not specific to MN103E010, the file names aren't good.

I realise that, but I haven't been able to get any better names for them.

> Stranger names here.

How so?

David
