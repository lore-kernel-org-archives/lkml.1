Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXA3W3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXA3W3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXA3W3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:29:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:39182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbXA3W3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:29:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="41295159:sNHT17216397"
Date: Tue, 30 Jan 2007 13:57:09 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, vatsa@in.ibm.com,
       clameter@sgi.com, tglx@linutronix.de, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Patch: dynticks: idle load balancing
Message-ID: <20070130135709.B32010@unix-os.sc.intel.com>
References: <20061211155304.A31760@unix-os.sc.intel.com> <20061213224317.GA2986@elte.hu> <20061213231316.GA13849@elte.hu> <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070116113505.GA6294@elte.hu>; from mingo@elte.hu on Tue, Jan 16, 2007 at 12:35:05PM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed response. I was away on vacation.

Please let me know if you still see this issue with the latest -rt kernel.

thanks,
suresh

On Tue, Jan 16, 2007 at 12:35:05PM +0100, Ingo Molnar wrote:
> 
> Suresh,
> 
> on the latest -rt kernel, when the dynticks load-balancer is enabled, 
> then a dual-core Core2 Duo test-system increases its irq rate from the 
> normal 15/17 per second to 300-400/sec - on a completely idle system(!). 
> Any idea what's going on? I'll disable the load balancer for now.
> 
> 	Ingo
