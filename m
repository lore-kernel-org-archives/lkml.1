Return-Path: <linux-kernel-owner+w=401wt.eu-S966620AbXEGUad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966620AbXEGUad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966613AbXEGUab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:30:31 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5712 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966592AbXEGUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:30:30 -0400
Subject: Re: Need help debugging RT-preempt patch
From: Daniel Walker <dwalker@mvista.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       dirk.behme@googlemail.com, linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <463F7449.2020509@am.sony.com>
References: <463F7449.2020509@am.sony.com>
Content-Type: text/plain
Date: Mon, 07 May 2007 13:28:39 -0700
Message-Id: <1178569719.3164.6.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 11:47 -0700, Tim Bird wrote:
> I've applied patch-2.6.21-rt1 to a 2.6.21 kernel I'm using.
> With the patch applied, but no RT-Preempt options enabled,
> I'm getting network failures (eth0 transmit timeouts) on
> an OMAP board.

Are you sure you don't have HardIRQS in Threads enabled? Also are you
sure the kernel boots without the rt patch applied.

> I'm not sure what the best method is to debug this.  Should
> I turn on the latency tracer?  Should I post my configuration?
> Should I try to break up the patch and apply changes in small doses?
> I'm not familiar with the network code, or with the RT code (yet),
> so for now I'm kind of stumbling in the dark.
> 
> Note that I have other patches applied, for platform support
> for the OMAP.
> 
> I believe ARM (or OMAP) is not supported by the RT-preempt patch
> at the moment.  But I'd like to carry the patches in my kernel even
> if the options for RT-preempt are off, because I want to experiment
> with RT-preempt on other platforms (x86 and MIPS).

ARM is supported, but specific boards are hit or miss.. 

I've had OMAP working _in the past_ with this patch applied,

http://lkml.org/lkml/2006/12/10/59

There was also a patch released on one of the OMAP lists a while back
from Dirk Behme to get OMAP working on a mor recent rt release..

Daniel

