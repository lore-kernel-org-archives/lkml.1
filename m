Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZCCH65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZCCH65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZCCH6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:58:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZCCH6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:58:48 -0500
Date: Tue, 3 Mar 2009 08:58:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       lizf@cn.fujitsu.cn, menage@google.com
Subject: Re: + cgroup-memcg-show-correct-file-mode.patch added to -mm tree
Message-ID: <20090303075828.GA10019@elte.hu>
References: <200902262100.n1QL0Vvi021877@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902262100.n1QL0Vvi021877@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

>  		.name = "usage_in_bytes",
>  		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
>  		.read_u64 = mem_cgroup_read,
> +		.mode = 0444

Uhm, we've got symbols for permission bits for a reason. 
(S_IRUGO in this case)

> +		.mode = 0444

Ditto.

> +		.mode = 0200

Ditto. (S_IWUSR)

> +		.mode = 0444

Ditto.

	Ingo
