Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbXCIWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbXCIWLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXCIWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:11:47 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:42633 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbXCIWLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:11:46 -0500
Date: Fri, 9 Mar 2007 14:10:46 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309221046.GV10574@sequoia.sous-sol.org>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309214704.GA20988@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> i am worried whether /any/ future change to the upstream kernel's design 
> can be adopted via paravirt_ops, via the current VMI ABI. And by /any/ i 
> mean truly any. And whether that can be done is not a function of the 
> flexibility of paravirt_ops, it's a function of the flexibility of the 
> VMI ABI.

i'm not really one to argue on behalf of VMI, but i don't think it's as
dire make it out.  the VMI is client code of pv_ops, and as the kernel
changes that client code will simply have to adapt.  of course there are
theoretical limitations, but let's keep it grounded to practical reality.
the whole premise is evolution.  so throw out specific issues, and let's
adapt rather than fall deep into theoretical rhetoric.

thanks,
-chris
