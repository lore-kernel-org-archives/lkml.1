Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbXEKJ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbXEKJ6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbXEKJ57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:57:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbXEKJ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:57:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070510161946.96ff0784.akpm@linux-foundation.org>
References: <20070510161946.96ff0784.akpm@linux-foundation.org> <20070510143334.19485.26042.stgit@warthog.cambridge.redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] AFS: Fix interminable loop in afs_write_back_from_locked_page()
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 11 May 2007 10:57:53 +0100
Message-ID: <10145.1178877473@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> More than one would expect, given that it is recommended in
> Documentation/SubmitChecklist, which everyone reads ;)

Which states incorrectly:

| 22: Newly-added code has been compiled with `gcc -W'.  This will generate
|     lots of noise, but is good for finding bugs like "warning: comparison
|     between signed and unsigned".

-W does not imply -Wsign-compare, at least not on my gcc.

David
