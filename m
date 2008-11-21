Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYKUIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYKUIKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYKUIKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:10:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbYKUIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:10:13 -0500
Date: Fri, 21 Nov 2008 00:09:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for
 doing very slow work items [ver #41]
Message-Id: <20081121000913.6506d7b6.akpm@linux-foundation.org>
In-Reply-To: <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 14:41:45 +0000 David Howells <dhowells@redhat.com> wrote:

> Create a dynamically sized pool of threads for doing very slow work items, such
> as invoking mkdir() or rmdir() - things that may take a long time and may
> sleep, holding mutexes/semaphores and hogging a thread, and are thus unsuitable
> for workqueues.

umm, if they're slow, why not create a kernel thread per operation? 
Why add the thread pool?

