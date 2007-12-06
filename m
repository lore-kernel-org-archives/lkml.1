Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbXLFBk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbXLFBk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXLFBkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:40:18 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:38937 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751539AbXLFBkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:40:16 -0500
X-YMail-OSG: UZoW34kVM1nn7qOaOmN12waB3Rm_0CkMgE_Tdqb23ev1KfrHxMbll9kW56C8o9YAmbpMsW5cSA--
X-RocketYMMF: rancidfat
Date: Wed, 5 Dec 2007 17:40:15 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 4/7] KEYS: Add keyctl function to get a security label
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Daniel J Walsh <dwalsh@redhat.com>
Cc: dhowells@redhat.com, casey@schaufler-ca.com, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <25702.1196904505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <289732.78389.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > inode_getsecurity and getprocattr directly return the strings.
> > Admittedly, the whole interface could be cleaned up and made far more
> > consistent, but I don't think he necessarily has to go through the
> > getsecid + secid_to_secctx sequence if he only wants the secctx.
> 
> It's what Daniel Walsh wanted.

Name dropper. And we don't have a convention, really. So go ahead
with key_getsecurity or key_getsecctx, as you choose. At some point
we should either change inode_getsecurity to inode_getsecctx or
secid_to_secctx to secid_to_security. Not the problem of the day.



Casey Schaufler
casey@schaufler-ca.com
