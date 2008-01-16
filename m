Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYAPQtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYAPQtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYAPQtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:49:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYAPQtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:49:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Xine.LNX.4.64.0801161156410.24959@us.intercode.com.au>
References: <Xine.LNX.4.64.0801161156410.24959@us.intercode.com.au> <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, Trond.Myklebust@netapp.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 00/26] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 16 Jan 2008 16:48:46 +0000
Message-ID: <30642.1200502126@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > The SELinux base code will also need updating to have the security class, lest
> > the following error appear in dmesg:
> > 
> > 	context_struct_compute_av:  unrecognized class 69
> 
> Alternately, what's needed is a newer policy which supports unknown 
> permission classes.  Any recent distro policy should have this.

I'm seeing this with an up to date Fedora 7 installation.  Do I need F8
instead?

David
