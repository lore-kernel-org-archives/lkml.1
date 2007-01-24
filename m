Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXAXU3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXAXU3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932503AbXAXU3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:29:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbXAXU3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:29:47 -0500
Date: Wed, 24 Jan 2007 12:29:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@redhat.com>, Jim Meyering <meyering@redhat.com>
Subject: Re: [PATCH 3/3] NFS: Ensure we support selinux xattrs
In-Reply-To: <1169669288.15390.155.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.64.0701241228050.3606@woody.linux-foundation.org>
References: <20070124195307.21259.64156.stgit@lade.trondhjem.org> 
 <20070124195457.21259.53047.stgit@lade.trondhjem.org>
 <1169669288.15390.155.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jan 2007, Stephen Smalley wrote:
> 
> I don't think you want to just set the incore inode security state on
> the client side, as that won't be preserved.

I agree. The fix seems much worse than the problem.

It doesn't seem to be a kernel bug (except insofar that you can argue that 
enabling ACL's at all is a bug), and it also doesn't look like a 
regression.

		Linus
