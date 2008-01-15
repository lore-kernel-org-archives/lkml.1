Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYAOWXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYAOWXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYAOWXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:23:20 -0500
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:47494 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758567AbYAOWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:23:18 -0500
X-YMail-OSG: VSHNMgAVM1k7jx7w..EY4QHFulFKzEWOXabF4XNPDI8mFztPlIvdLG5bX72o5GZT8.FlXBr_wQ--
X-RocketYMMF: rancidfat
Date: Tue, 15 Jan 2008 14:23:14 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com,
       Daniel J Walsh <dwalsh@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <6778.1200434110@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <372376.51168.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > The cache files are created by the cachefiles kernel module, not by the
> > userspace daemon, and the userspace daemon doesn't need to directly
> > read/write them at all
> 
> That is correct.
> 
> > (but I think it does need to be able to unlink them?).
> 
> Indeed.
> 
> > The userspace daemon merely identifies the directory where the cache should
> > live as part of configuring the cache when enabling it.
> 
> That is the way it currently works, yes.
>  
> > Hence, it is fine to use a fixed label for the cache files (systemhigh
> > in a MLS world), and to let the directory's label serve as the basis for
> > it.
> 
> That is what I currently do.  SELinux rules are provided to grant the
> appropriate file accesses to the override label used by the kernel module, so
> that it can't go and stamp on files with the wrong label.
> 
> > Only the cachefiles kernel module directly reads and writes the files.
> 
> Correct.

Well, my bad, and thank you for clearing up my misunderstanding.


Casey Schaufler
casey@schaufler-ca.com
