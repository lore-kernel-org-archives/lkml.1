Return-Path: <linux-kernel-owner+w=401wt.eu-S1765648AbZDBRJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765648AbZDBRJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZDBRJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:09:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35970 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbZDBRJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:09:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030353.17713.nickpiggin@yahoo.com.au>
References: <200904030353.17713.nickpiggin@yahoo.com.au> <200904030225.16372.nickpiggin@yahoo.com.au> <6362.1238687462@redhat.com> <200904030315.03606.nickpiggin@yahoo.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Thu, 02 Apr 2009 18:09:15 +0100
Message-ID: <7249.1238692155@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Comments about PG_private still stand.

Replies about PG_private still stand.

It's owned by fs/buffer.c, and if the 'netfs' uses that, then PG_private is
not available.  Though, as I said, fs/buffer.c could be broken of its control
of the bit.

David
