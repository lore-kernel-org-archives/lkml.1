Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbXIEPj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbXIEPj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbXIEPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:39:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbXIEPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:39:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1188996257.3119.7.camel@raven.themaw.net>
References: <1188996257.3119.7.camel@raven.themaw.net> <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org> <5813.1188892468@redhat.com> 
To: Ian Kent <raven@themaw.net>
Cc: dhowells@redhat.com, Bill Davidsen <davidsen@tmr.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 05 Sep 2007 16:37:51 +0100
Message-ID: <3558.1189006671@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> wrote:

> But what about mounting with different protocol, tcp vs udp for example.

I was referring specifically to the R/O / R/W variants of the same mount.  Any
flag variation that varies the way the NFS client talks to the NFS server must
either result in a new superblock or be ignored.

David
