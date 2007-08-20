Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbXHTMKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbXHTMKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbXHTMKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:10:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbXHTMK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:10:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org> <29015.1187178055@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: Adding a security parameter to VFS functions
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 20 Aug 2007 13:09:52 +0100
Message-ID: <11466.1187611792@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Would you object greatly to functions like vfs_mkdir() gaining a security
> > parameter?  What I'm thinking of is this:
> ...
> Why the *hell* would mkdir() be so magical as to need something like that?

If you look again, you'll notice that I said "functions like vfs_mkdir()".  I
was I using vfs_mkdir() as an example.  I didn't mean to apply this to
directory creation only.  It would need to apply to all the vfs_*() entry
points called by nfsd and cachefiles.

David
