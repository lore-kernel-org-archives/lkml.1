Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbXKOWzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbXKOWzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbXKOWzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:55:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbXKOWzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:55:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071115144007.08760570.akpm@linux-foundation.org>
References: <20071115144007.08760570.akpm@linux-foundation.org> <20071113165316.18700.67752.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] FRV: Fix the extern declaration of kallsyms_num_syms [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 15 Nov 2007 22:55:37 +0000
Message-ID: <16597.1195167337@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> hm, OK, so it lines up with what scripts/kallsyms.c presently does.

I'm sure there's a way to pass the kallsyms_num_syms value directly by way of
the linker rather than consigning it to a bit of memory.

The immediately obvious way is to declare it to be at an address that it the
symbol count value, and then C can do "&kallsyms_num_syms" to get at it.
Horrible, I know, but I'm not sure it's worse than some of the other stuff we
do.

David
