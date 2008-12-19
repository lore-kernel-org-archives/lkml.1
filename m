Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbYLSSd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbYLSSd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYLSSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:33:16 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36878 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYLSSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:33:16 -0500
Date: Fri, 19 Dec 2008 12:33:13 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/45] Make the slow work pool configurable [ver #41]
Message-ID: <20081219183313.GB17113@us.ibm.com>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144155.10667.38747.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120144155.10667.38747.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Make the slow work pool configurable through /proc/sys/kernel/slow-work.
> 
>  (*) /proc/sys/kernel/slow-work/min-threads
> 
>      The minimum number of threads that should be in the pool as long as it is
>      in use.  This may be anywhere between 2 and max-threads.
> 
>  (*) /proc/sys/kernel/slow-work/max-threads
> 
>      The maximum number of threads that should in the pool.  This may be
>      anywhere between min-threads and 255 or NR_CPUS * 2, whichever is greater.
> 
>  (*) /proc/sys/kernel/slow-work/vslow-percentage
> 
>      The percentage of active threads in the pool that may be used to execute
>      very slow work items.  This may be between 1 and 99.  The resultant number
>      is bounded to between 1 and one fewer than the number of active threads.
>      This ensures there is always at least one thread that can process very
>      slow work items, and always at least one thread that won't.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>
