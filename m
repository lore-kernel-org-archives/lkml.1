Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZLDJtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZLDJtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZLDJtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:49:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbZLDJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:49:18 -0500
Subject: Re: [PATCH 3/3] sched: update normalized values on user updates
 via proc v2
From: Peter Zijlstra <peterz@infradead.org>
To: ehrhardt@linux.vnet.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, Holger.Wolf@de.ibm.com,
       epasch@de.ibm.com, schwidefsky@de.ibm.com
In-Reply-To: <1259579808-11357-4-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
	 <1259579808-11357-4-git-send-email-ehrhardt@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 10:49:12 +0100
Message-ID: <1259920152.3977.1820.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 12:16 +0100, ehrhardt@linux.vnet.ibm.com wrote:
> @@ -301,7 +303,9 @@ static struct ctl_table kern_table[] = {
>                 .data           = &sysctl_sched_shares_ratelimit,
>                 .maxlen         = sizeof(unsigned int),
>                 .mode           = 0644,
> -               .proc_handler   = &proc_dointvec,
> +               .proc_handler   = &sched_proc_update_handler,
> +               .extra1         = &min_sched_shares_ratelimit,
> +               .extra2         = &max_sched_shares_ratelimit,
>         }, 

While I don't object to that change it really should have been a
separate patch.

And at the very least the changelog should have said something about it.

Anyway, took all 3 patches.

