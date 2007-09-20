Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbXITELq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbXITELq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 00:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXITELe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 00:11:34 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:44965 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbXITELc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 00:11:32 -0400
Message-ID: <46F1F2EE.1010904@kernel.org>
Date: Wed, 19 Sep 2007 21:11:26 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] CRED: Move the effective capabilities into the cred
 struct
References: <20070919161749.8334.26064.stgit@warthog.procyon.org.uk> <20070919161805.8334.96808.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070919161805.8334.96808.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Howells wrote:
> Move the effective capabilities mask from the task struct into the credentials
> record.
> 
> Note that the effective capabilities mask in the cred struct shadows that in
> the task_struct because a thread can have its capabilities masks changed by
> another thread.  The shadowing is performed by update_current_cred() which is
> invoked on entry to any system call that might need it.

OOC If we were to simply drop support for one process changing the
capabilities of another, would we need this patch?

Thanks

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFG8fLrQheEq9QabfIRApPOAKCHAoazhTTpY/qSjdmRZxDptqeqiACfd4Q7
mdIPx+xpG19ih9uiVv1NSBU=
=TfZd
-----END PGP SIGNATURE-----
