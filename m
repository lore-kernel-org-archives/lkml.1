Return-Path: <linux-kernel-owner+w=401wt.eu-S933415AbZHDWD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbZHDWD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbZHDWD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:03:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60199 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400AbZHDWD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:03:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090804210101.GB13499@us.ibm.com>
References: <20090804210101.GB13499@us.ibm.com> <20090804184334.GC8442@us.ibm.com> <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145546.17676.98776.stgit@warthog.procyon.org.uk> <5007.1249417827@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and expired keys.
Date: Tue, 04 Aug 2009 23:00:52 +0100
Message-ID: <25511.1249423252@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> This won't require keyring->sem?

Why should it?  A keyring merely points at a key, and if you follow this line
of argument, then every keyring pointing at a key would have to be locked.

David
