Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZD2PJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZD2PJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZD2PI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:08:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbZD2PI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:08:56 -0400
Date: Wed, 29 Apr 2009 07:58:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       dada1@cosmosbay.com, benh@kernel.crashing.org, gallatin@myri.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Cc: tip-bot for Eric Dumazet <dada1@cosmosbay.com>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, benh@kernel.crashing.org, gallatin@myri.com,
       tglx@linutronix.de, mingo@elte.hu, stable@kernel.org
Subject: Re: [tip:sched/urgent] sched: account system time properly
Message-Id: <20090429075818.5ca17efb.akpm@linux-foundation.org>
In-Reply-To: <tip-f5f293a4e3d0a0c52cec31de6762c95050156516@git.kernel.org>
References: <49F84BC1.7080602@cosmosbay.com>
	<tip-f5f293a4e3d0a0c52cec31de6762c95050156516@git.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 13:09:19 GMT tip-bot for Eric Dumazet <dada1@cosmosbay.com> wrote:

> Commit-ID:  f5f293a4e3d0a0c52cec31de6762c95050156516
> Gitweb:     http://git.kernel.org/tip/f5f293a4e3d0a0c52cec31de6762c95050156516
> Author:     Eric Dumazet <dada1@cosmosbay.com>
> AuthorDate: Wed, 29 Apr 2009 14:44:49 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 29 Apr 2009 15:02:28 +0200
> 
> sched: account system time properly
> 
> ...
> 
> Reported-by: Andrew Gallatin <gallatin@myri.com>
> Re-reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: rick.jones2@hp.com
> Cc: brice@myri.com
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> LKML-Reference: <49F84BC1.7080602@cosmosbay.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

The regression was present in 2.6.29, so a -stable backport (and cc!) is
appropriate.

