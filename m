Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbXITISo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbXITISo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761803AbXITIQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:16:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761789AbXITIQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:16:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46F1F2EE.1010904@kernel.org>
References: <46F1F2EE.1010904@kernel.org> <20070919161749.8334.26064.stgit@warthog.procyon.org.uk> <20070919161805.8334.96808.stgit@warthog.procyon.org.uk>
To: Andrew Morgan <morgan@kernel.org>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] CRED: Move the effective capabilities into the cred struct
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 20 Sep 2007 09:15:15 +0100
Message-ID: <10709.1190276115@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan <morgan@kernel.org> wrote:

> OOC If we were to simply drop support for one process changing the
> capabilities of another, would we need this patch?

Well, the patch could be less, but there's still the possibility of a kernel
service wanting to override the capabilities mask.

David
