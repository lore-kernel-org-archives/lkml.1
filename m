Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXJVQq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXJVQq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXJVQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:46:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbXJVQqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:46:50 -0400
Date: Mon, 22 Oct 2007 12:46:42 -0400
From: Rik van Riel <riel@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 - autofs broken
Message-ID: <20071022124642.340ff067@bree.surriel.com>
In-Reply-To: <1193024720.3197.13.camel@raven.themaw.net>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071020011310.30abc16b@bree.surriel.com>
	<1193024720.3197.13.camel@raven.themaw.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 11:45:19 +0800
Ian Kent <raven@themaw.net> wrote:

> > Oct 20 00:38:52 kenny automount[2293]: cache_readlock: mapent cache
> > rwlock lock failed
> 
> This is quite strange, normally it should never fail and, in all the
> time version 5 has been available the maximum number of read locks has
> never been exceeded.
> 
> Is there anything unusual going on like a server down causing autofs
> to issue a number of mounts that are all waiting to time out?

Not that I know.  If I reboot the system into 2.6.23 or 2.6.23-git,
things work just fine though.  That makes me think the server is not
the issue.
 
> > Oct 20 00:38:52 kenny automount[2293]: unexpected pthreads error:
> > 11 at 65 in cache.c
> 
> Mmm .. if this is a genuine autofs issue maybe I need to handle EAGAIN
> returns but that would mean blocking which probably isn't good and I'd
> rather not if we can avoid it.

I do not know if this an autofs issue or the result of something
else in 2.6.23-mm1.

> > I am not sure if this is due to autofs changes or changes in some
> > other code that was merged.  If you can think of any suspicious
> > change that I should test, please let me know.
> > 
> 
> Is there anything in the log, an autofs4 kernel trace perhaps?

Nope, the only two lines that I found in the log are above...

Nothing in dmesg either.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
