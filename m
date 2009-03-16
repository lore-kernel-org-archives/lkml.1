Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbZCPLcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbZCPLcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZCPLcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:32:10 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38233 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZCPLcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:32:08 -0400
Date: Mon, 16 Mar 2009 12:27:11 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
Subject: Re: [PULL] cpumask updates for s390
Message-ID: <20090316122711.0e106d8f@skybase>
In-Reply-To: <200903161444.38974.rusty@rustcorp.com.au>
References: <200903161444.38974.rusty@rustcorp.com.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 14:44:38 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
>   Kyle McMartin (1):
>         parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-s390.git master
> 
> Rusty Russell (4):
>       cpumask: remove cpu_coregroup_map: s390
>       cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: s390
>       cpumask: Use accessors code.: s390
>       cpumask: use mm_cpumask() wrapper: s390

Pulled the patches, fixed the small hickup in __tlb_flush_full
(local_cpumask vs. &local_cpumask) and added the four patches to the
features branch on git30. The kernel still runs fine.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

