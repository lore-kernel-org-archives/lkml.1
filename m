Return-Path: <linux-kernel-owner+w=401wt.eu-S1764578AbXFRR6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764578AbXFRR6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761397AbXFRR62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:58:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32845 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760566AbXFRR62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:58:28 -0400
Date: Mon, 18 Jun 2007 23:36:57 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au, clameter@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070618180657.GC21037@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070613184741.GC8125@linux.vnet.ibm.com> <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com> <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618151215.GA9750@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:42:15PM +0530, Srivatsa Vaddagiri wrote:
> If you don't have CONFIG_NUMA enabled,
> then we won't have cross-node (i.e cross-cpu) load balancing.

Mmm ..that is not correct. I found that disabling CONFIG_NUMA leads
to better load balance on the problem system (i.e w/o any patches
applied 2.6.22-rc4-mm2 leads to good distribution of rcu readers on all
4 cpus).

Anyway, the patch is still needed for scenarios like you originally
tested with.

-- 
Regards,
vatsa
