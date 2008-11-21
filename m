Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYKUCRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYKUCRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 21:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYKUCRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 21:17:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYKUCRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 21:17:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121001539.GA5889@x200.localdomain>
References: <20081121001539.GA5889@x200.localdomain> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144236.10667.83390.stgit@warthog.procyon.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/45] FS-Cache: Add use of /proc and presentation of statistics [ver #41]
Date: Fri, 21 Nov 2008 02:17:21 +0000
Message-ID: <16493.1227233841@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:

> This is overly complex for unclear need. Just set_printf() all these lines
> and drop iterator business. Use single_open()! Ditto for histo stuff.

There is no set_printf() in Linus's tree.  Did you mean seq_printf(), or is
this something I might find in -mm?

David
