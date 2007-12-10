Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXLJX5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXLJX5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXLJX47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:56:59 -0500
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:37189 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751663AbXLJX46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:56:58 -0500
X-YMail-OSG: mOezpPwVM1ngZSgI_j7ZGmV.ElqQy4ALl5ZrOq.pUyxfC6Fti4Y4Nih4iBCCCzqaeeAFY4rBWg--
X-RocketYMMF: rancidfat
Date: Mon, 10 Dec 2007 15:56:57 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <25991.1197330258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <112273.38088.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > That happens to me when interfaces are described in SELinux terms. I
> > still don't care much for multiple contexts, and I don't have a good
> > grasp of how you'll deal with Smack, or any LSM other than SELinux.
> 
> Me neither.  I understand SELinux somewhat, though it's got a lot of wibbly
> bits, and WinNT's security system, but I have no experience of the other
> stuff.
> 
> > Just as Stephen mentions, I also don't see the generality that a change
> > of this magnitude really ought to provide.
> 
> Perhaps it should be a specific interface, solely for cachefiles's use then.

That would help focus things, to be sure. I don't know if that
focus will speed things up or slow them down, but I think that
attempting to accomodate SELinux/NFS, with the state that effort
is in, will only lead to tears.


Casey Schaufler
casey@schaufler-ca.com
