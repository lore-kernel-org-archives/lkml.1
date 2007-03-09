Return-Path: <linux-kernel-owner+w=401wt.eu-S2993143AbXCIVIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993143AbXCIVIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993144AbXCIVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:08:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49178 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993143AbXCIVIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:08:45 -0500
Date: Fri, 9 Mar 2007 13:06:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
In-Reply-To: <20070309201257.GA5761@elte.hu>
Message-ID: <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org>
References: <20070309180230.GA17988@elte.hu>
 <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
 <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org>
 <20070309201257.GA5761@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Ingo Molnar wrote:
>
>   _new kernel must not break on an older hypervisor_

Total red herring. AGAIN.

The paravirt_ops isn't a 1:1 hypervisor ABI.

If we change paravirt_ops to be higher-level ops (as we should), yes, the 
paravirt->VMI layer needs to be extended to have the "higher->lower" 
translation. But at no point did we break the hypervisor.

Anyway, please don't even bother cc'ing or replying to me any more.

		Linus
