Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbXIDHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbXIDHvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXIDHvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:51:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbXIDHvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:51:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1188562298.6649.39.camel@heimdal.trondhjem.org>
References: <1188562298.6649.39.camel@heimdal.trondhjem.org> <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188535485.6626.85.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org> <1188536658.6626.98.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org> <20070831074028.GR21979@unthought.net> <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org> 
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 04 Sep 2007 08:51:13 +0100
Message-ID: <5739.1188892273@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

>         - the NFSv4 delegation model breaks: the client will be using
>         OPEN when it could use cached opens. More importantly, when
>         performing an operation that requires it to return the
>         delegation on the aliased file, it won't know until the server
>         sends it a callback.

Perhaps sharing could be the default on NFSv4 and non-sharing for 2 & 3?
After all, NFSv4 is supposed to be able to handle local caching on disk.

David
