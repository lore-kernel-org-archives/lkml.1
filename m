Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbXIZNb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbXIZNb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758983AbXIZNbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:31:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758915AbXIZNbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:31:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1190643719.487.41.camel@moss-spartans.epoch.ncsc.mil>
References: <1190643719.487.41.camel@moss-spartans.epoch.ncsc.mil> <20070919161749.8334.26064.stgit@warthog.procyon.org.uk> <20070919161759.8334.11581.stgit@warthog.procyon.org.uk> <20070924140003.GA25689@vino.hallyn.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part of it into struct cred
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 26 Sep 2007 14:30:19 +0100
Message-ID: <22215.1190813419@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Precisely when to use one identity vs. the other though isn't always
> clear, and the potential for accidental divergence is also a concern.

What should auditing use in audit_filter_rules() when dealing with
AUDIT_SUBJ_* cases?  Should the SUBJ cases use the subjective SID and the
AUDIT_OBJ_* cases use the objective SID?  On the other hand AUDIT_OBJ_* cases
don't seem to have anything to do with tasks.

David
