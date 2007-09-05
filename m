Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbXIEPga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbXIEPga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbXIEPgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:36:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbXIEPgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:36:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46DEA293.9020705@tmr.com>
References: <46DEA293.9020705@tmr.com> <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org> <5813.1188892468@redhat.com> 
To: Bill Davidsen <davidsen@tmr.com>
Cc: dhowells@redhat.com, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 05 Sep 2007 16:34:41 +0100
Message-ID: <3495.1189006481@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen <davidsen@tmr.com> wrote:

> I think Al had a good idea there, that is nice and clean. What about bind
> mounts, will that just fall out?

I don't see that it should be a problem since the vfsmount is copied.

David
