Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXKEQF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXKEQF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXKEQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:05:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbXKEQFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:05:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b1c6420f0711030907g10149e1asda1afe4e2f3c8e02@mail.gmail.com>
References: <b1c6420f0711030907g10149e1asda1afe4e2f3c8e02@mail.gmail.com> <20071029122759.2846.83510.stgit@warthog.procyon.org.uk> <20071029122809.2846.58795.stgit@warthog.procyon.org.uk> <b1c6420f0710300740t5c708933x7ab1716c76504c57@mail.gmail.com> <20112.1193774645@redhat.com> <b1c6420f0710301703n5c330ae2idb75c9a5703d5e7c@mail.gmail.com> <13581.1193831186@redhat.com> 
To: "Suzuki Takashi" <suzuki.takashi@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] [PATCH 2/2] MN10300: Add the MN10300/AM33 architecture to the kernel [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 05 Nov 2007 15:38:05 +0000
Message-ID: <15038.1194277085@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Takashi <suzuki.takashi@gmail.com> wrote:

> I'm very annoyed and a bit surprised to hear they admitted such a big
> change so easily.

Why be annoyed?  It's not actually a substantial change.

> You and I know there are consumer devices already out running the am33
> port of the kernel.

Yes, and have been for years, I suspect.

> What triggered me to comment on your patch was that its directory and file
> structure is very different from the ones there.  There are no cpu-, proc-
> and unit- directories and no names with mn103e10_* there.

Things are allowed to change.

> The kernels there seem to be already running on several processors,
> some of which are with AM34 cores that you concern about, according to
> the #ifdefs there.

Yes.

> > The problem is how much?  I could just move all the cpu-am33v2/ files into
> > the dir above, but what happens if an incompatible CPU core is introduced?
> 
> How does your client say?

MEI have agreed for me to do that.  I can always undo it later if sufficiently
incompatible CPU cores arise that warrant that level of segregation.

David
