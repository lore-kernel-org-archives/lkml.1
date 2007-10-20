Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXJTFN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXJTFN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXJTFNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:13:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXJTFNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:13:19 -0400
Date: Sat, 20 Oct 2007 01:13:10 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: 2.6.23-mm1 - autofs broken
Message-ID: <20071020011310.30abc16b@bree.surriel.com>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 21:31:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 
> - I've been largely avoiding applying anything since rc8-mm2 in an
> attempt to stabilise things for the 2.6.23 merge.

Between rc8-mm2 and 2.6.23-mm1, autofs stopped working in the
-mm kernel.

Instead of mounting my home directory, I get these messages in
/var/log/messages:

Oct 20 00:38:52 kenny automount[2293]: cache_readlock: mapent cache
rwlock lock failed
Oct 20 00:38:52 kenny automount[2293]: unexpected pthreads error: 11 at
65 in cache.c

I am not sure if this is due to autofs changes or changes in some other
code that was merged.  If you can think of any suspicious change that
I should test, please let me know.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
