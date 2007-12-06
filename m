Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbXLFB3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbXLFB3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLFB2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:28:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbXLFB2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:28:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1196887108.16006.121.camel@moss-spartans.epoch.ncsc.mil>
References: <1196887108.16006.121.camel@moss-spartans.epoch.ncsc.mil> <138670.64371.qm@web36609.mail.mud.yahoo.com>
To: Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>
Cc: dhowells@redhat.com, casey@schaufler-ca.com, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/7] KEYS: Add keyctl function to get a security label
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 06 Dec 2007 01:28:25 +0000
Message-ID: <25702.1196904505@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> inode_getsecurity and getprocattr directly return the strings.
> Admittedly, the whole interface could be cleaned up and made far more
> consistent, but I don't think he necessarily has to go through the
> getsecid + secid_to_secctx sequence if he only wants the secctx.

It's what Daniel Walsh wanted.

David
