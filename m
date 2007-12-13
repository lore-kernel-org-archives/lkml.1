Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbXLMPhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbXLMPhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbXLMPh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:37:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbXLMPh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:37:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197557384.20226.21.camel@moss-spartans.epoch.ncsc.mil>
References: <1197557384.20226.21.camel@moss-spartans.epoch.ncsc.mil> <1197488021.1125.138.camel@moss-spartans.epoch.ncsc.mil> <1197473127.1125.50.camel@moss-spartans.epoch.ncsc.mil> <81862.27432.qm@web36605.mail.mud.yahoo.com> <32168.1197484170@redhat.com> <668.1197499783@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 13 Dec 2007 15:36:59 +0000
Message-ID: <21666.1197560219@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> It is just a way of carving up the permission space, typically based on
> object type, but it can essentially be arbitrary.  The check in this
> case seems specific to cachefiles since it is controlling an operation
> on the /dev/cachefiles interface that only applies to cachefiles
> internal operations, so making a cachefiles class seems reasonable.

Can you specify what sort of permissions you're thinking of providing for
tasks to operate on this class?  Can an object of this class 'operate' on
other objects, or can only process-class objects do that?

How does an object of this class acquire a label?  What is an object of this
class?  Is it a "cache"?  Or were you thinking of a "module"?

David
