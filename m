Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXKMPos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXKMPos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbXKMPok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:44:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXKMPok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:44:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071109115207.e435f19b.akpm@linux-foundation.org>
References: <20071109115207.e435f19b.akpm@linux-foundation.org> <20071106214820.3854.17402.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, jdi@l4x.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the extern declaration of kallsyms_num_syms
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 13 Nov 2007 15:44:30 +0000
Message-ID: <20134.1194968670@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +extern const unsigned long kallsyms_num_syms
> > +__nongpreldata __attribute__((weak));
> 
> umm, this makes Linux an frv-only operating system...

Oops.  Well... is there any other CPU?  Apart from MN10300, that is... :-)

I remember I had to fix a bunch of things like this before... I wonder how I
did it...

David

