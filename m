Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbXHNPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbXHNPxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbXHNPxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:53:42 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:43557 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753224AbXHNPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:53:40 -0400
X-YMail-OSG: WUdQNnoVM1msoaAQ1mctyz6nrbbB5DrZaxz7c211TQbiqZfLO_pLoKZc0EuDMdqdBPafbEYTfQ--
X-RocketYMMF: rancidfat
Date: Tue, 14 Aug 2007 08:53:39 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1079.1187084397@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <861956.50630.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > With Smack you can leave the label alone, raise CAP_MAC_OVERRIDE,
> > do your business of setting the label correctly, and then drop
> > the capability. No new hooks required.
> 
> That sounds like a contradiction.  How can you both leave it alone and set
> it?

Whoops, sorry. You leave the process label alone and explicitly
set the file label using the xattr interfaces.


Casey Schaufler
casey@schaufler-ca.com
