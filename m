Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbXLKVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbXLKVSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXLKVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:18:14 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:24395 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751036AbXLKVSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:18:13 -0500
X-YMail-OSG: IWfFFRQVM1nMig9UGw38fM1wnNPaChsbYOneT7C30XO2J77eiohacOBaUO2VWCHwt9TRbcbJDw--
X-RocketYMMF: rancidfat
Date: Tue, 11 Dec 2007 13:18:12 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <9789.1197405725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <395440.2938.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

...
> 
> How about I just stick the context in /etc/cachefilesd.conf as a textual
> configuration item and have the daemon pass that as a string to the
> cachefiles
> kernel module, which can then ask LSM if it's valid to set this context as an
> override, given the daemon's own security context?  That seems entirely
> reasonable to me.

Works for Smack. I can't say definitively, but I think it will
work for SELinux. Beyond that and we're into the fuzzy bit of the
LSM.


Casey Schaufler
casey@schaufler-ca.com
