Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYH0QSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYH0QSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYH0QSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:18:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbYH0QSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:18:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080827160439.GA12085@us.ibm.com>
References: <20080827160439.GA12085@us.ibm.com> <200808262057.51606.agruen@suse.de> <20080827135206.GA12919@us.ibm.com> <200808271729.18220.agruen@suse.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, Andreas Gruenbacher <agruen@suse.de>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 27 Aug 2008 17:13:24 +0100
Message-ID: <26995.1219853604@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> (Also note that if you have such users, you'll want to ask David Howells not
> to push the patch he has floated removing the ability to pass caps to
> another task altogether when CONFIG_SECURITY_FILE_CAPABILITIES=n :)

Ugh.  My patch removes the ability to pass caps to another task under all
circumstances because to do otherwise means that I have to make the kernel use
RCU locking for a task to access its own creds.  If you want this, I'll have
to redo all my later patches.

David
