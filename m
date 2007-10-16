Return-Path: <linux-kernel-owner+w=401wt.eu-S1765309AbXJPItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765309AbXJPItS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbXJPItF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:49:05 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:27595 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758609AbXJPItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:49:03 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
Date: Tue, 16 Oct 2007 10:48:56 +0200
User-Agent: KMail/1.9.7
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <200710151028.34407.borntraeger@de.ibm.com> <m1zlykj8zl.fsf_-_@ebiederm.dsl.xmission.com> <200710161819.11231.nickpiggin@yahoo.com.au>
In-Reply-To: <200710161819.11231.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161048.56848.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Oktober 2007 schrieb Nick Piggin:
> While I said it was a good fix when I saw the patch earlier, I think
> it's not closing the entire hole, and as such, Christian's patch is
> probably the way to go for stable.

That would be my preferred method. Merge Erics and my fixup for 2.6.24-rc.
The only open questions is, what was the reiserfs problem? Is it still
causes by Erics patches?

> For mainline, *if* we want to keep the old rd.c around at all, I
> don't see any harm in this patch so long as Christian's is merged
> as well. Sharing common code is always good.

While the merge window is still open, to me the new ramdisk code seems
more like a 2.6.25-rc thing. We actually should test the behaviour in 
low memory scenarios. What do you think?

Christian
