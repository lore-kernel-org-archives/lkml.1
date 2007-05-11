Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbXEKJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbXEKJ6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbXEKJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:58:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756348AbXEKJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:58:32 -0400
Date: Fri, 11 May 2007 02:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] AFS: Fix interminable loop in
 afs_write_back_from_locked_page()
Message-Id: <20070511025822.a5aa5240.akpm@linux-foundation.org>
In-Reply-To: <8792.1178876963@redhat.com>
References: <20070510161946.96ff0784.akpm@linux-foundation.org>
	<20070510143334.19485.26042.stgit@warthog.cambridge.redhat.com>
	<8792.1178876963@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 10:49:23 +0100 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Following bug was uncovered by compiling with '-W' flag:
> > 
> > gcc -W finds a number of fairly scary bugs.
> 
> Do you mean in my code specifically?  Or in the kernel in general?

In general.

>  As far as
> I can tell -W only finds an eye-glazingly large quantity of 'unused parameter'
> warnings in AFS and AF_RXRPC.

Yes, it's a shame that there doesn't seem to be a fine-grained way of
turning on -W's useful bits.

