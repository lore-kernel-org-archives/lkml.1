Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbXIDIDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbXIDIDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXIDIDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:03:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbXIDIDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:03:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org> <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 04 Sep 2007 09:02:51 +0100
Message-ID: <6053.1188892971@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In other words, let's assume that the user has /some/nfs/mount mounted 
> over NFS, and wants to re-mount it (or even just a subset of it) somewhere 
> else, the sane thing to do is not to mount it again, but to just do

What about a superset?  What about two intersecting sets?  Bind mounts aren't
quite it for this problem, and in any case your suggestion of:


