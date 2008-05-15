Return-Path: <linux-kernel-owner+w=401wt.eu-S1765254AbYEOV57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765254AbYEOV57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYEOV5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:57:49 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:41815 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYEOV5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:57:48 -0400
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
From: Andi Kleen <andi@firstfloor.org>
References: <482C9FC5.2070508@cosmosbay.com>
Date: Thu, 15 May 2008 23:57:45 +0200
In-Reply-To: <482C9FC5.2070508@cosmosbay.com> (Eric Dumazet's message of "Thu, 15 May 2008 22:40:37 +0200")
Message-ID: <87ej83z0va.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 May 2008 21:50:44.0801 (UTC) FILETIME=[BA2F4B10:01C8B6D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:
> Instead of wasting NR_CPUS*128 bytes (on i386), we now use
> num_possible_cpus*sizeof(local_t) bytes.
>
> On a typical distro, where NR_CPUS=8, 

More typical would be NR_CPUS=128, with NR_CPUS=four digits 
when Mike Travis et.al. are finished

> shiping 2000 modules, we reduce

Surely only the loaded modules count? Perhaps 20-30.

But it's a cool improvement. Very nice.

-Andi
