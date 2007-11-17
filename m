Return-Path: <linux-kernel-owner+w=401wt.eu-S935127AbXKQA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbXKQA3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 19:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759756AbXKQA3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 19:29:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49445
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbXKQA3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 19:29:12 -0500
Date: Fri, 16 Nov 2007 16:29:05 -0800 (PST)
Message-Id: <20071116.162905.143357955.davem@davemloft.net>
To: dean@arctic.org
Cc: andi@firstfloor.org, mucci@cs.utk.edu, akpm@linux-foundation.org,
       gregkh@suse.de, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       ptools-perfapi@cs.utk.edu
Subject: Re: perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.0.9999.0711160943470.15441@twinlark.arctic.org>
References: <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu>
	<p737ikicjbn.fsf@bingen.suse.de>
	<alpine.DEB.0.9999.0711160943470.15441@twinlark.arctic.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: dean gaudet <dean@arctic.org>
Date: Fri, 16 Nov 2007 09:51:08 -0800 (PST)

> On Fri, 16 Nov 2007, Andi Kleen wrote:
> 
> > I didn't see a clear list. 
> 
> - cross platform extensible API for configuring perf counters
> - support for multiplexed counters
> - support for virtualized 64-bit counters
> - support for PC and call graph sampling at specific intervals
> - support for reading counters not necessarily with sampling
> - taskswitch support for counters
> - API available from userland
> - ability to self-monitor: need select/poll/etc interface
> - support for PEBS, IBS and whatever other new perf monitoring 
>   infrastructure the vendors through at us in the future
> - low overhead:  must minimize the "probe effect" of monitoring
> - low noise in measurements:  cannot achieve this in userland
> 
> permon2 has all of this and more i've probably neglected...

I want to state that even though I've been a stickler on the system
call stuff, in general I want to see perfmon2 go into tree and I agree
with how most of the infrastructure is implemented and the features it
provides.
