Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYHLAzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYHLAzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYHLAz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:55:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYHLAz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:55:26 -0400
Message-ID: <48A0DDEC.704@zytor.com>
Date: Mon, 11 Aug 2008 17:48:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem
 with fpu state changes
References: <489DC15D.9070308@zytor.com> <20080809185224.GH13158@linux-os.sc.intel.com> <20080809193724.GJ13158@linux-os.sc.intel.com> <20080810030521.GA2332@gondor.apana.org.au> <20080811190131.GL13158@linux-os.sc.intel.com> <20080811192203.GC12788@elte.hu> <48A0920B.30306@zytor.com> <20080811201901.GN13158@linux-os.sc.intel.com> <20080812003938.GC18230@gondor.apana.org.au> <48A0DC6D.8040409@zytor.com> <20080812004641.GB18444@gondor.apana.org.au>
In-Reply-To: <20080812004641.GB18444@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Mon, Aug 11, 2008 at 05:42:21PM -0700, H. Peter Anvin wrote:
>> That's not sufficient, though, because you have to track all the state 
>> and how it relates to everything.  You now have to track both the 
>> userspace FPU state and the potential kernel FPU state.  The VIA 
>> instructions are special (in the short bus to school sense) in that they 
>> use a mechanism intended to protect specific state to protect -- exactly 
>> nothing.
> 
> Sorry, the kernel TS state is what I meant.  I'm definitely not
> advocating the saving of the kernel FPU state.  This is only for
> things like the VIA (which also exists for other processors, see
> the xor SSE stuff in include/asm-x86).

No, there you are actually using the FPU state (which includes the SSE 
state.)

	-hpa
