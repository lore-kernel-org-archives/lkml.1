Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYAPA7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYAPA7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYAPA7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:59:37 -0500
Received: from namei.org ([69.55.235.186]:47402 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753584AbYAPA7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:59:36 -0500
Date: Wed, 16 Jan 2008 11:58:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com,
       Trond.Myklebust@netapp.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 00/26] Permit filesystem local caching
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
Message-ID: <Xine.LNX.4.64.0801161156410.24959@us.intercode.com.au>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008, David Howells wrote:

> The SELinux base code will also need updating to have the security class, lest
> the following error appear in dmesg:
> 
> 	context_struct_compute_av:  unrecognized class 69

Alternately, what's needed is a newer policy which supports unknown 
permission classes.  Any recent distro policy should have this.


- James
-- 
James Morris
<jmorris@namei.org>
