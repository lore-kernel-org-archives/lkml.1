Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbXKFLJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbXKFLJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXKFLJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:09:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbXKFLJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:09:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071106022505.f32b1bff.akpm@linux-foundation.org>
References: <20071106022505.f32b1bff.akpm@linux-foundation.org> <20071025163352.5057.59344.stgit@warthog.procyon.org.uk> <20071025163514.5057.4558.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/31] IGET: Stop FreeVXFS from using iget() and read_inode() [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 06 Nov 2007 11:09:23 +0000
Message-ID: <1363.1194347363@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Not completely trivial - the ino_t -> unsigned long conversion needs to be
> propagated fairly widely in there.

I'll just make it unsigned long.  That's what iget() took as the inode number
parameter type, so it can't behave any differently as a first guess.

David
