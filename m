Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYAOQEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYAOQEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYAOQEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:04:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYAOQEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:04:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1200409002.9669.43.camel@moss-spartans.epoch.ncsc.mil>
References: <1200409002.9669.43.camel@moss-spartans.epoch.ncsc.mil> <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <17868.1199897484@redhat.com> <3466.1200319279@redhat.com> 
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Daniel J Walsh <dwalsh@redhat.com>,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 15 Jan 2008 16:03:17 +0000
Message-ID: <32507.1200412997@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> >  (3) Check that the kernel may create files as a particular secid (this
> >      could be specified indirectly by specifying an inode, which would
> >      hide the secid inside the LSM).
> 
> I don't think this check is on the kernel per se but rather the ability
> of the daemon to nominate a secid for use on files created later by the
> kernel module.

Hmmm...  At the moment the cachefiles module works out for itself what the
file label should be by looking at the root directory it was given and
assuming the label on that is what it's going to be using.  Are you suggesting
this should be specified directly instead by the daemon?

David
