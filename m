Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbXITRt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbXITRt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbXITRts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:49:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXITRtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:49:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <14969.1190308632@redhat.com>
References: <14969.1190308632@redhat.com> <956034.72880.qm@web36610.mail.mud.yahoo.com>
Cc: dhowells@redhat.com, casey@schaufler-ca.com, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part of it into struct cred
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 20 Sep 2007 18:33:16 +0100
Message-ID: <15093.1190309596@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > So it sounds like what you'd be happiest with would be a separate task
> > struct hand crafted to he the right "object" and "subject" attributes.

Actually, that whilst that is sort of feasible for CacheFiles[*], it is not
really feasible for NFSd.  NFSd possesses a set of daemons that have a
standard objective context and substitute a lot of different subjective
contexts as they perform VFS operations on behalf of remote clients.

  [*] But in practice quite icky from other points of view.

David
