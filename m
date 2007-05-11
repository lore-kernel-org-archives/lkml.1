Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbXEKJto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbXEKJto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbXEKJtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:49:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXEKJtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:49:31 -0400
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
Date: Fri, 11 May 2007 10:49:23 +0100
Message-ID: <8792.1178876963@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > Following bug was uncovered by compiling with '-W' flag:
> 
> gcc -W finds a number of fairly scary bugs.

Do you mean in my code specifically?  Or in the kernel in general?  As far as
I can tell -W only finds an eye-glazingly large quantity of 'unused parameter'
warnings in AFS and AF_RXRPC.

David
