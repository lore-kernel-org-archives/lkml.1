Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbXLLWzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbXLLWzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbXLLWza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:55:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136AbXLLWz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:55:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197488108.1125.141.camel@moss-spartans.epoch.ncsc.mil>
References: <1197488108.1125.141.camel@moss-spartans.epoch.ncsc.mil> <66139.71689.qm@web36604.mail.mud.yahoo.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 12 Dec 2007 22:55:09 +0000
Message-ID: <715.1197500109@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> More likely, run it at build time in your .spec file to generate
> cachefiles.conf,

I don't think sticking it in cachefiles.conf is a good idea necessarily.
That has to be an administrator modifiable file.  Is there a program I could
make cachefiles run directly and capture the output of that could give me the
info I want?

> then run it again maybe upon a policy update or if the user selects a
> different policy.

How do I do that?

David
