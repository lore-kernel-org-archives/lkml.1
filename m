Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXJ3Qx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXJ3Qx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXJ3Qxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:53:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbXJ3Qxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:53:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com>
References: <b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com> <20071029122759.2846.83510.stgit@warthog.procyon.org.uk> <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com> <15631.1193753689@redhat.com>
To: "Suzuki Takashi" <suzuki.takashi@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 30 Oct 2007 16:53:38 +0000
Message-ID: <27157.1193763218@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Takashi <suzuki.takashi@gmail.com> wrote:

> But the arch name change does not affect running kernels on consumer devices.

uname says mn10300.

> Drastic changes in the directory and file structures will have
> a much greater impact than that.

Like renaming the arch/mn10300 and include/asm-mn10300 directories and having
to tell people already using ARCH=mn10300 that they've got to change.

> This submission is a good chance for the new arch name.

It's also a good time to leave it as is, IMO.  This isn't precisely a new
arch.  It's been around a few years.  It just hasn't been posted upstream till
now.  People are using it, however.

> New contributors cannot recognize the am33 glibc is for the mn10300 Linux.

They can if they're told so, plus if they've got the CPU docs to hand, it
should be more obvious.  The AM33 is a variant of the MN10300 arch as far as I
can tell.

David
