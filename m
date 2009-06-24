Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZFXX4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZFXX4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZFXX4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:56:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbZFXX4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:56:42 -0400
Date: Wed, 24 Jun 2009 16:55:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and
 improve lpage NUMA support
Message-Id: <20090624165508.30b88343.akpm@linux-foundation.org>
In-Reply-To: <1245850216-31653-1-git-send-email-tj@kernel.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 22:30:06 +0900
Tejun Heo <tj@kernel.org> wrote:

> This patchset is available in the following git tree and will be
> published in for-next if there's no major objection.  It might get
> rebased before going into for-next.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git lpage-numa

<tries to read the patches>

Boy, this stuff is complicated.  Does it all work?

The Impact: lines were useful :)


I assume from the tremendous number of for_each_possible_cpu()s that
CPU hotplug awareness won't be happening.

Do we have a feeling for the amount of wastage here?  If

	num_possible_cpus() - num_online_cpus() == N

and N is large, what did it cost?

And what are reasonable values of N?
