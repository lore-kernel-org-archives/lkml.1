Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbXJZW3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbXJZW3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXJZW3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:29:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbXJZW3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:29:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071026122637.f9b86bdd.akpm@linux-foundation.org>
References: <20071026122637.f9b86bdd.akpm@linux-foundation.org> <20071026154210.30983.67470.stgit@warthog.procyon.org.uk> <20071026154215.30983.32978.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 1/2] MN10300: Permit AOUT library support to be suppressed in ELF binfmt
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 26 Oct 2007 23:29:07 +0100
Message-ID: <32536.1193437747@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> hm, seems a bit ungainly.  Why can't we just make all the aout things in
> binfmt_elf.c depend upon CONFIG_BINFMT_AOUT?

That works too, I guess.  I'll change it.

David
