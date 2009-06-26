Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbZFZAoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbZFZAoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZFZAn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:43:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:60208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZFZAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:43:57 -0400
Message-ID: <4A4419AA.2040400@kernel.org>
Date: Fri, 26 Jun 2009 09:43:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: maximilian attems <max@stro.at>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, ink@jurassic.park.msu.ru
Subject: Re: >= 2.6.30 broken alpha smp build
References: <20090625090842.GA17936@stro.at> <20090625115423.6a31b49c.akpm@linux-foundation.org>
In-Reply-To: <20090625115423.6a31b49c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 26 Jun 2009 00:43:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This is the
> 
> #define PER_CPU_ATTRIBUTES	__used
> 
> in arch/alpha/include/asm/percpu.h, added by 
> 
> commit 9267b4b3880d00dc2dab90f1d817c856939114f7
> Author:     Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> AuthorDate: Sat Jun 21 03:25:39 2008 +0400
> Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Fri Jun 20 16:46:10 2008 -0700
> 
>     alpha: fix module load failures on smp (bug #10926)
> 
> There's no indication in the changelog why this was added and afacit no
> other architectures do it.  So I'm at a loss to help here. 

The __used attribute is dropped by a patch in percpu patchset as it
caused build warning on my test builds and wasn't even effective
as-was (overriden by later NULL definition).  Ivan, any ideas why it's
there?

Thanks.

-- 
tejun
