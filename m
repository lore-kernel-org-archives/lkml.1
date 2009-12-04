Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZLDJtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZLDJtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZLDJtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:49:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbZLDJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:49:18 -0500
Subject: Re: [PATCH 2/3] sched: make tunable scaling style configurable
From: Peter Zijlstra <peterz@infradead.org>
To: ehrhardt@linux.vnet.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, Holger.Wolf@de.ibm.com,
       epasch@de.ibm.com, schwidefsky@de.ibm.com
In-Reply-To: <1259579808-11357-3-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
	 <1259579808-11357-3-git-send-email-ehrhardt@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 10:49:13 +0100
Message-ID: <1259920153.3977.1821.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 12:16 +0100, ehrhardt@linux.vnet.ibm.com wrote:

> +++ linux-2.6-git-schedrecalc/kernel/sched.c
> @@ -7010,6 +7010,21 @@ static void update_sysctl(void)
>  	unsigned int cpus = max(num_online_cpus(), 8U);
>  	unsigned int factor = 1 + ilog2(cpus);
>  
> +	unsigned int factor;
> +

Now that won't compile will it ;-)

3rd patch removes the extra factor again, fixed it up properly.

