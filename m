Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbXLLWdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbXLLWdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXLLWd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:33:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXLLWdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:33:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <830252.82380.qm@web36604.mail.mud.yahoo.com>
References: <830252.82380.qm@web36604.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 12 Dec 2007 22:32:48 +0000
Message-ID: <612.1197498768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> > This fd selects the
> > particular cache context that a particular instance of a running daemon is
> > using.
> 
> Yes, but forgive me being slow, I don't see the problem.

I mean that it's not particularly sensible to have an auxiliary interface (say
a separate /sys/cachefiles file) for setting the cache context as there may be
several caches instantiated simply by opening /dev/cachefiles several times
and retaining all the file descriptors involved.

I meant this as information only.

David
