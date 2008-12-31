Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYLaN0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYLaN0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYLaN0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:26:41 -0500
Received: from ozlabs.org ([203.10.76.45]:46282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbYLaN0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:26:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/6] cpuset: convert to new cpumask API
Date: Wed, 31 Dec 2008 23:56:31 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <495B2EA6.7010808@cn.fujitsu.com>
In-Reply-To: <495B2EA6.7010808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812312356.32617.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 19:04:46 Li Zefan wrote:
> This patchset converts cpuset to use new cpumask API, and thus
> remove on stack cpumask_t to reduce stack usage.
> 
> Before:
>  # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
>  21
> After:
>  # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
>  0
> 
> The patchset is based on mmotm 2008-12-30-16-05.

Wow, thanks!

Rusty.
