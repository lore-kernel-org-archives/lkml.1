Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbZHQSqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbZHQSqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZHQSqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:46:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZHQSqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:46:35 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Kelly <mark@bifferos.com>,
       linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
From: Andi Kleen <andi@firstfloor.org>
References: <58001.1250437590@bifferos.com> <20090816155507.GA2791@elte.hu>
	<alpine.LNX.2.00.0908160317250.19588@cent.localnet>
	<20090816175204.GA28553@elte.hu>
	<alpine.LNX.2.00.0908160404300.20653@cent.localnet>
	<4A899A1D.8060808@zytor.com> <20090817180825.GA5558@elte.hu>
	<4A899FEA.9020707@zytor.com>
Date: Mon, 17 Aug 2009 20:46:32 +0200
In-Reply-To: <4A899FEA.9020707@zytor.com> (H. Peter Anvin's message of "Mon, 17 Aug 2009 11:22:34 -0700")
Message-ID: <871vnas2gn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 08/17/2009 11:08 AM, Ingo Molnar wrote:
>> 
>> X86_RDC321X already exists in arch/x86/Kconfig. It should probably 
>> grow a 'depends on PCI' rline or so.
>> 
>
> Sounds like it.

iirc the patch used early pci which is actually self contained
in its header. The main problem was that it didn't use it correctly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
