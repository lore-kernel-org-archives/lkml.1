Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXKUMvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXKUMvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 07:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXKUMvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 07:51:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXKUMvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 07:51:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071120184048.2b8c82cd.akpm@linux-foundation.org>
References: <20071120184048.2b8c82cd.akpm@linux-foundation.org> <20071120125029.dfd58d83.akpm@linux-foundation.org> <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <4742FACF.7040906@linux.vnet.ibm.com> <21076.1195608768@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 21 Nov 2007 12:49:34 +0000
Message-ID: <24561.1195649374@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> So... what went wrong with broken-out-2007-11-20-01-45.tar.gz?

It differs too much from Linus's base.

> But sometimes it doesn't work out very well.  There's lot of stuff
> outstanding again.  Immediate problems are from an x86 exec randomisation
> thingy in git-x86 and pie-executable-randomization.patch in -mm, which both
> hit on binfmt_elf.c

Hmmm...  I can't apply your combined patch:

	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/2.6.24-rc3-mm1.bz2

to Linus's GIT tree.  Quite a few errors occur.  Do you just use Linus's
released tarball as a base?

David
