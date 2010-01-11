Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724Ab0AKW4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0AKW4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895Ab0AKW4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:56:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab0AKW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:56:20 -0500
Date: Mon, 11 Jan 2010 14:55:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic id
 != 0 can boot
In-Reply-To: <1263245985.2859.497.camel@sbs-t61.sc.intel.com>
Message-ID: <alpine.LFD.2.00.1001111454060.17145@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>  <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>  <20100110023015.GA2253@in.ibm.com>  <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>  <20100110102638.GA7838@elte.hu> 
 <20100111045326.GA11725@in.ibm.com> <1263245985.2859.497.camel@sbs-t61.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Jan 2010, Suresh Siddha wrote:
> 
> So far, I don't see a need for the revert.

It's very easy. It breaks. You don't have a fix. We'll revert it.

There's no need to "see a need". That's not how it works. It works the 
other way around: I don't see a need for a known-broken patch, which is 
why it will be reverted since apparently you don't understand why it is 
broken.

		Linus
