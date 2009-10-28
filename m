Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZJ1HhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZJ1HhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbZJ1HhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:37:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33162 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149AbZJ1HhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:37:00 -0400
Date: Wed, 28 Oct 2009 08:34:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com
Subject: Re: [PATCH 06/10] bootmem: refactor free_all_bootmem_core
Message-ID: <20091028073432.GA19402@elte.hu>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1256712464-21472-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256712464-21472-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> From: Chris Wright <chrisw@sous-sol.org>
> 
> Move the loop that frees all bootmem pages back to page allocator into
> its own function.  This should have not functional effect and allows the
> function to be reused later.
> 
> Reviewed-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Small signoff-handling sidenote: in such cases (when you are handling 
other people's patches) the expected workflow is to add your SOB line 
after Chris's line, instead of the Reviewed-by line.

I.e. it should look like this:

  Signed-off-by: Chris Wright <chrisw@sous-sol.org>
  Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Showing the path of the patch - ending with your signoff.

Thanks,

	Ingo
