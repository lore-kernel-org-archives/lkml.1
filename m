Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbXLLWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbXLLWyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbXLLWyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:54:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXLLWyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:54:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <573241.88686.qm@web36613.mail.mud.yahoo.com>
References: <573241.88686.qm@web36613.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 12 Dec 2007 22:52:46 +0000
Message-ID: <698.1197499966@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> It would seem to me that security_secctx_to_secid() ought to suffice if the
> application code was written correctly.

That's not quite sufficient as there still needs to be a verification step to
make sure the caller is allowed to do this.

> Be aware that factors outside the LSM may be important, too. As Stephen
> points out elsewhere, Smack will require you have particular capabilities
> (CAP_MAC_OVERRIDE, CAP_MAC_ADMIN) while a DAC LSM may require
> CAP_DAC_OVERRIDE.

For what?

David
