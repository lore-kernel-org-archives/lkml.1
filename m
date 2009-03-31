Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbZCaWJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbZCaWJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbZCaWIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:08:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756970AbZCaWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:08:51 -0400
Date: Tue, 31 Mar 2009 15:00:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       mikew@google.com, rientjes@google.com, rohitseth@google.com,
       hugh@veritas.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
       edwintorok@gmail.com, lee.schermerhorn@hp.com, npiggin@suse.de
Subject: Re: [RFC v2][PATCH]page_fault retry with NOPAGE_RETRY
Message-Id: <20090331150046.16539218.akpm@linux-foundation.org>
In-Reply-To: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 11:40:19 -0800
Ying Han <yinghan@google.com> wrote:

> changelog[v2]:
> - reduce the runtime overhead by extending the 'write' flag of
>   handle_mm_fault() to indicate the retry hint.
> - add another two branches in filemap_fault with retry logic.
> - replace find_lock_page with find_lock_page_retry to make the code
>   cleaner.
> 
> todo:
> - there is potential a starvation hole with the retry. By the time the
>   retry returns, the pages might be released. we can make change by holding
>   page reference as well as remembering what the page "was"(in case the
>   file was truncated). any suggestion here are welcomed.
> 
> I also made patches for all other arch. I am posting x86_64 here first and
> i will post others by the time everyone feels comfortable of this patch.

I'm about to send this into Linus.  What happened to the patches for
other architectures?

Please send them over when convenient and I'll work on getting them
trickled out to arch maintainers, thanks.

