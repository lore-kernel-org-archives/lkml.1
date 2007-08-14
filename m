Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbXHNR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbXHNR7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932673AbXHNR6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:58:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932660AbXHNR62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:58:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <861956.50630.qm@web36613.mail.mud.yahoo.com>
References: <861956.50630.qm@web36613.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 14 Aug 2007 18:58:00 +0100
Message-ID: <9409.1187114280@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> Whoops, sorry. You leave the process label alone and explicitly
> set the file label using the xattr interfaces.

That's the wrong way to do things.  There'd then be a window in which
cachefilesd (the userspace daemon) could attempt to view the file when the
file has the wrong label attached.

David
