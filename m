Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXIZOb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXIZOb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbXIZOX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:23:57 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:36313 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760811AbXIZOXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:23:51 -0400
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part
	of it into struct cred
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, linux-audit@redhat.com
In-Reply-To: <22215.1190813419@redhat.com>
References: <1190643719.487.41.camel@moss-spartans.epoch.ncsc.mil>
	 <20070919161749.8334.26064.stgit@warthog.procyon.org.uk>
	 <20070919161759.8334.11581.stgit@warthog.procyon.org.uk>
	 <20070924140003.GA25689@vino.hallyn.com>  <22215.1190813419@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 26 Sep 2007 10:14:47 -0400
Message-Id: <1190816087.15779.81.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 14:30 +0100, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Precisely when to use one identity vs. the other though isn't always
> > clear, and the potential for accidental divergence is also a concern.
> 
> What should auditing use in audit_filter_rules() when dealing with
> AUDIT_SUBJ_* cases?  Should the SUBJ cases use the subjective SID and the
> AUDIT_OBJ_* cases use the objective SID?  On the other hand AUDIT_OBJ_* cases
> don't seem to have anything to do with tasks.

(cc'd linux-audit)

As you say, I don't think AUDIT_OBJ_* has anything to do with tasks,
just object labels (like inode labels).

I think you likely want the actor SID / subject SID or whatever you want
to call it for AUDIT_SUBJ_*.

-- 
Stephen Smalley
National Security Agency

