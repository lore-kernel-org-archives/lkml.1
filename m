Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbXHISID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbXHISID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXHISHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:07:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbXHISHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:07:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <162335.27499.qm@web36605.mail.mud.yahoo.com>
References: <162335.27499.qm@web36605.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be obtained [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 09 Aug 2007 19:06:55 +0100
Message-ID: <20932.1186682815@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> This is SELinux specific functionality. It should not be an LSM
> interface. 

This is what I worked out in conjunction with the denizens of the SELinux
mailing list.  What would you have me do differently?  Change things like:

	u32 (*act_as_secid)(u32 secid);

to something like:

	void (*act_as_secid)(const char *newsecdata, u32 newseclen,
			     char *oldsecdata, u32 *oldseclen);

David
