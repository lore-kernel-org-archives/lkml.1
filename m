Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbXLMQE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbXLMQE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbXLMQEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:04:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXLMQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:04:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197557461.20226.24.camel@moss-spartans.epoch.ncsc.mil>
References: <1197557461.20226.24.camel@moss-spartans.epoch.ncsc.mil> <1197488108.1125.141.camel@moss-spartans.epoch.ncsc.mil> <66139.71689.qm@web36604.mail.mud.yahoo.com> <715.1197500109@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 13 Dec 2007 16:03:47 +0000
Message-ID: <21903.1197561827@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> Yes, we could easily make a simple program that just invokes a
> libselinux function that in turn grabs the proper context from some
> context configuration file under /etc/selinux/$SELINUXTYPE/contexts/ and
> outputs it.  Dan can help with that.

That sounds nicely genericisable, perhaps even for any LSM.

	/usr/bin/lsm-get-context cachefiles

It does have to be able to come up with different contexts for different
caches, but that can be controlled by changing the name supplied to it.

David
