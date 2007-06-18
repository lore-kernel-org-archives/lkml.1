Return-Path: <linux-kernel-owner+w=401wt.eu-S1762788AbXFRLKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788AbXFRLKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760961AbXFRLKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:10:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760227AbXFRLKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:10:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070616091514.8e5dc1d3.akpm@linux-foundation.org>
References: <20070616091514.8e5dc1d3.akpm@linux-foundation.org> <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] NFS: Make NFS root work again
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Mon, 18 Jun 2007 12:09:35 +0100
Message-ID: <22425.1182164975@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> What is not working, and how does this patch fix it?

It turns out that this patch is unnecessary.  The problem had to do with the
initcalling of default_rootfs() (or lack of initcalling in this case).  I
fixed vmlinux.lds.S and it works now.

David
