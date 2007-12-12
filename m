Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbXLLTow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbXLLTow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXLLTon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:44:43 -0500
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:43875 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752616AbXLLTom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:44:42 -0500
X-YMail-OSG: odxENXgVM1ktpQ2_bVmRBtw22DTNsmgdbCGz6vj5wdzsS8S2MVcI_ZaEvtnNX9DxG_t5Sx9WbQ--
X-RocketYMMF: rancidfat
Date: Wed, 12 Dec 2007 11:44:41 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <32187.1197484466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <830252.82380.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > What sort of authorization are you thinking of? I would expect
> > that to have been done by cachefileselinuxcontext (or
> > cachefilesspiffylsmcontext) up in userspace. If you're going to
> > rely on userspace applications for policy enforcement they need
> > to be good enough to count on after all.
> 
> It can't be done in userspace, otherwise someone using the cachefilesd
> interface can pass an arbitrary context up.

Yes, but I would expect that interface to be protected (owned by root,
mode 0400). If /dev/cachefiles has to be publicly accessable make it
a privileged ioctl.

> The security context has to be
> passed across the file descriptor attached to /dev/cachefiles along with the
> other configuration parameters as a text string.

I got that.

> This fd selects the
> particular cache context that a particular instance of a running daemon is
> using.

Yes, but forgive me being slow, I don't see the problem.


Casey Schaufler
casey@schaufler-ca.com
