Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYLEPJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYLEPJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYLEPIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:08:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbYLEPIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:08:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0812051407130.25248@blonde.anvils>
References: <Pine.LNX.4.64.0812051407130.25248@blonde.anvils> <20081205133014.14725.79974.stgit@warthog.procyon.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       bfields@fieldses.org, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from fh_to_dentry()/fh_to_parent() [ver #2]
Date: Fri, 05 Dec 2008 15:03:07 +0000
Message-ID: <15132.1228489387@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> 
> I think it's still wrong in shmem_fh_to_dentry(): you've fixed
> the early return, but there'd be another return NULL if !inode?

You're right...  Grrr.

David
