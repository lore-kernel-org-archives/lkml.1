Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbXBVXIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbXBVXIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbXBVXIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:08:25 -0500
Received: from mga07.intel.com ([143.182.124.22]:37169 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbXBVXIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:08:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,207,1170662400"; 
   d="scan'208"; a="185906957:sNHT50141560"
Date: Thu, 22 Feb 2007 14:33:00 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [patch 2/2] sched: dynticks idle load balancing - v2
Message-ID: <20070222143259.B14789@unix-os.sc.intel.com>
References: <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com> <20070216180335.A8744@unix-os.sc.intel.com> <20070216180842.B8744@unix-os.sc.intel.com> <20070222032654.GD12137@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070222032654.GD12137@wotan.suse.de>; from npiggin@suse.de on Thu, Feb 22, 2007 at 04:26:54AM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 04:26:54AM +0100, Nick Piggin wrote:
> This is really ugly, sorry :(

hm. myself and others too thought it was a simple and nice idea.

> My suggestion for handling this was to increase the maximum balance
> interval for an idle CPU, and just implement a global shutdown when
> the entire system goes idle.
> 
> The former should take care of the power savings issues for bare metal
> hardware, and the latter should solve performance problems for many idle
> SMP guests. It should take very little code to implement.

coming to max balance interval will be challenging. It needs to save
power and at the same time respond to load changes fast enough.

> If that approach doesn't cut it, then at least we can have some numbers
> to see how much better yours is so we can justify including it.
> 
> If you are against my approach, then I can have a try at coding it up
> if you like?

Sure. If you can provide a patch, I will be glad to provide power and
performance comparision numbers with both the approaches.

thanks,
suresh
