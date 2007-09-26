Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbXIZO6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbXIZO6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbXIZO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:58:34 -0400
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:40688 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754508AbXIZO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:58:33 -0400
X-YMail-OSG: Ctbv8oYVM1m9IECYWJvxEpWac8TDfIw1MrKJxyHAZ8FsOT6B
X-RocketYMMF: rancidfat
Date: Wed, 26 Sep 2007 07:58:32 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part of it into struct cred
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <22215.1190813419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <402619.1696.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Precisely when to use one identity vs. the other though isn't always
> > clear, and the potential for accidental divergence is also a concern.
> 
> What should auditing use in audit_filter_rules() when dealing with
> AUDIT_SUBJ_* cases?  Should the SUBJ cases use the subjective SID and the
> AUDIT_OBJ_* cases use the objective SID?  On the other hand AUDIT_OBJ_* cases
> don't seem to have anything to do with tasks.

I believe that you'll need to audit both sets of credentials.
I think that for audit filtering you will need to have the ability
to filter on either. It's no different from the euid/ruid split.


Casey Schaufler
casey@schaufler-ca.com
