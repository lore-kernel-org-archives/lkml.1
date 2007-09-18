Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXIRISk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXIRISk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXIRIS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:18:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39777 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbXIRISZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:18:25 -0400
Date: Tue, 18 Sep 2007 17:19:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       ckrm-tech@lists.sourceforge.net
Subject: Re: [PATCH] Hookup group-scheduler with task container
 infrastructure
Message-Id: <20070918171945.d0593a08.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910171049.GA16048@linux.vnet.ibm.com>
References: <20070910171049.GA16048@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 22:40:49 +0530
Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> +	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * num_possible_cpus(), GFP_KERNEL);
> +	if (!tg->cfs_rq)
> +		goto err;
> +	tg->se = kzalloc(sizeof(se) * num_possible_cpus(), GFP_KERNEL);
> +	if (!tg->se)
> +		goto err;
Sorry for very lazy responce..

num_possible_cpus() just returns # of possible cpus. Then it will not return
Max-cpu-id to be used. I think just use NR_CPUS here is an easy way.

Thanks,
-Kame

