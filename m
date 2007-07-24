Return-Path: <linux-kernel-owner+w=401wt.eu-S935948AbXGXJne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935948AbXGXJne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbXGXJnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:43:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50384 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760241AbXGXJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:43:19 -0400
Date: Tue, 24 Jul 2007 11:43:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Li, Tong N" <tong.n.li@intel.com>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070724094313.GB26724@one.firstfloor.org>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <p73ir8aubzx.fsf@bingen.suse.de> <1185225015.3593.15.camel@tongli.jf.intel.com> <46A51CB8.1090400@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A51CB8.1090400@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 03:25:12PM -0600, Chris Friesen wrote:
> Li, Tong N wrote:
> >On the other hand, if locking does
> >become a problem for certain systems/workloads, increasing
> >sysctl_base_round_slice can reduce the locking frequency and alleviate
> >the problem, at the cost of being relatively less fair across the CPUs. 
> 
> If locking does become a problem, it may make sense to switch instead to 
> a lockless algorithm of some sort...

That usually has the same issue with cache lines. It would be better
to analyze first if such global synchronization is really needed.
I hope not.

-Andi
