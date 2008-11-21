Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbYKUQJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbYKUQJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYKUQJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:09:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47879 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYKUQJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:09:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121160744.17135.78532.stgit@warthog.procyon.org.uk>
References: <20081121160744.17135.78532.stgit@warthog.procyon.org.uk>
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix error handling in is_user_addr_valid()
Date: Fri, 21 Nov 2008 16:09:28 +0000
Message-ID: <17246.1227283768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Fix error handling in is_user_addr_valid() in NOMMU mode to check whether
> find_vma() actually worked or not.  This checks whether ptrace() is allowed to
> access an address.

Ignore this patch, please.  It's dependent on another patch you don't have
yet.

David
