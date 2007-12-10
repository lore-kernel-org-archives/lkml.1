Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbXLJRJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbXLJRJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 12:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXLJRIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 12:08:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbXLJRIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 12:08:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
References: <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 10 Dec 2007 17:07:53 +0000
Message-ID: <25037.1197306473@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > +	tsec->create_sid = SECINITSID_UNLABELED;
> > +	tsec->keycreate_sid = SECINITSID_UNLABELED;
> > +	tsec->sockcreate_sid = SECINITSID_UNLABELED;

Cleared means what?  Setting to 0?  Or is there some other constant I should
use for that?

David
