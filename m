Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbXEaP4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbXEaP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXEaPz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:55:58 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbXEaPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:55:58 -0400
Date: Thu, 31 May 2007 08:55:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
Message-Id: <20070531085556.11649c70.akpm@linux-foundation.org>
In-Reply-To: <m164695hqm.fsf@ebiederm.dsl.xmission.com>
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
	<465A6078.6010804@yahoo.com.au>
	<465A6197.5010402@yahoo.com.au>
	<m1veed82mz.fsf@ebiederm.dsl.xmission.com>
	<465BB6C2.7050704@yahoo.com.au>
	<m164695hqm.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 05:56:33 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:

> >> I suspect that is a pretty rare case but it does indeed seem to exist
> >> as a problem.
> >
> > I think so too. But either we have some misunderstanding of the
> > codepaths involved, or the author of the comments there didn't
> > consider this case, so...
> 
> Do someone needs to stand up and write the additional patches.
> Do we have a maintainer for fs/buffer.c?

me, if any one, I guess.  But I haven't really been following
this discussion - too long and slow ;)  'twould be good if you
could reprise it all in one email, presumably in diff -u form..
