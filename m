Return-Path: <linux-kernel-owner+w=401wt.eu-S1751078AbZFOHbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbZFOHbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZFOHay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:30:54 -0400
Received: from mga12.intel.com ([143.182.124.36]:34431 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751664AbZFOHax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154337282"
Date: Mon, 15 Jun 2009 15:14:30 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf record/report: Add call graph /
	call chain profiling
Message-ID: <20090615071429.GA7314@ywang-moblin2.bj.intel.com>
References: <tip-3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:36:32PM +0000, tip-bot for Ingo Molnar wrote:
> +struct ip_chain_event {
> +	__u16 nr;
> +	__u16 hv;
> +	__u16 kernel;
> +	__u16 user;
> +	__u64 ips[];
> +};
> +

The following error on my 32bit box:

cc1: warnings being treated as errors
builtin-report.c: In function 'process_overflow_event':
builtin-report.c:984: error: cast to pointer from integer of different
size
make: *** [builtin-report.o] Error 1

unsigned long ips[] perhaps?
