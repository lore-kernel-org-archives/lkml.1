Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYAWRXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYAWRXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbYAWRVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:21:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbYAWRVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:21:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080123004459.15602.45031.stgit@warthog.procyon.org.uk>
References: <20080123004459.15602.45031.stgit@warthog.procyon.org.uk> <20080123004344.15602.35710.stgit@warthog.procyon.org.uk>
To: Trond.Myklebust@netapp.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH 14/27] FS-Cache: Recruit a couple of page flags for cache management
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 23 Jan 2008 17:20:09 +0000
Message-ID: <11099.1201108809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

>  (2) PG_fscache_write (PG_owner_priv_2)
> 
>      The marked page is being written to the local cache.  The page may not be
>      modified whilst this is in progress.

Oops.  wait_on_page_owner_priv_2() should use PG_owner_priv_2 rather than
PG_private_2.  I'll release a new patchset shortly.

David
