Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbXIUPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbXIUPmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbXIUPlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:41:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582AbXIUPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:41:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <718847.32805.qm@web36601.mail.mud.yahoo.com>
References: <718847.32805.qm@web36601.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/22] Introduce credential record
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 21 Sep 2007 16:40:16 +0100
Message-ID: <9072.1190389216@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> > One thing I'm not certain about is how this should interact with /proc,
> > which can display some of the stuff in the cred struct.  I think it may be
> > necessary to have a real cred pointer and an effective cred pointer, with
> > the contents of /proc coming from the real, but the effective governing
> > what actually goes on.
> 
> I think you want the effective values to show up in /proc.

Perhaps - but bear in mind that in the override case they weren't set by the
process itself.

David
