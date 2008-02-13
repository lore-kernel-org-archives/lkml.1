Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYBMMf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYBMMf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYBMMfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:35:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYBMMfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:35:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080212154749.de96c277.akpm@linux-foundation.org>
References: <20080212154749.de96c277.akpm@linux-foundation.org> <20080208160424.14436.6965.stgit@warthog.procyon.org.uk> <20080208160429.14436.88582.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KEYS: Check starting keyring as part of search
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 13 Feb 2008 12:35:14 +0000
Message-ID: <7988.1202906114@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	    (keyring->expiry && now.tv_sec >= keyring->expiry))
> 
> time_after()?

Possibly.  tv_sec oughtn't to wrap, though.  I thought time_after() is really
for comparing jiffies which might wrap.

David
