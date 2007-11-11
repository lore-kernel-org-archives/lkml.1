Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbXKKT7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbXKKT7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXKKT7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:59:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbXKKT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:59:14 -0500
Date: Sun, 11 Nov 2007 11:58:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Unionfs: stop using iget() and read_inode()
Message-Id: <20071111115817.b1862bc9.akpm@linux-foundation.org>
In-Reply-To: <200711111838.lABIc4Im012713@agora.fsl.cs.sunysb.edu>
References: <200711070648.lA76miPW005794@agora.fsl.cs.sunysb.edu>
	<200711111838.lABIc4Im012713@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007 13:38:04 -0500 Erez Zadok <ezk@cs.sunysb.edu> wrote:

> Andrew, the following small patch is critical to have after:
> 
> iget-stop-unionfs-from-using-iget-and-read_inode.patch

Thanks

> Question: since the above patch isn't in my unionfs.git tree (not until the
> whole iget series makes it to Linus), then do you prefer if I give you a
> replacement patch to the above patch, or a small incremental one; either
> way, you can choose to fold the above and below patches into one.

Incrementals are usually preferred.  But it's usually more convenient for the
originator to generate a new patch, and I will almost always turn that into
an incremental so that I can review what was changed.  The downside to this
is that nobody else will be able to see what was changed.

So there are pros and cons and I'm not particularly fussed either way,
really.  But if a patch is large and has already had some testing and
review and has been in -mm for a while then that's when wholesale
replacement becomes problematic: it pretty much sets us back to square one.
