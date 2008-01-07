Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYAGNME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYAGNME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbYAGNKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:10:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010AbYAGNKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:10:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200801072233.51294.nickpiggin@yahoo.com.au>
References: <200801072233.51294.nickpiggin@yahoo.com.au> <200712211208.24026.nickpiggin@yahoo.com.au> <6481.1198175619@redhat.com> <18996.1199291223@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 07 Jan 2008 13:09:03 +0000
Message-ID: <7972.1199711343@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> No. I mean call the bit PG_private2. That way non-pagecache and
> filesystems that don't use fscache can use it.

The bit is called PG_owner_priv_2, and then 'subclassed' to PG_fscache, much
like PG_owner_priv_1 is 'subclassed' to PG_checked as was recommended.

David
