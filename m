Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYJBIxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYJBIxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYJBIxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:53:34 -0400
Received: from www.tglx.de ([62.245.132.106]:60272 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbYJBIxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:53:33 -0400
Date: Thu, 2 Oct 2008 10:53:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Howard Chu <hyc@symas.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: APIC frequency too slow on HP dv5z
In-Reply-To: <48E28443.7060708@symas.com>
Message-ID: <alpine.LFD.1.10.0810021052410.5549@apollo.tec.linutronix.de>
References: <48E28443.7060708@symas.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Howard Chu wrote:

> More often than not, on a warm boot I see something like this
> 
> msg.new:[    1.940031] Using local APIC timer interrupts.
> msg.new:[    1.944031] APIC timer calibration result 466046
> msg.new:[    1.944031] Detected 0.466 MHz APIC timer.
> msg.new:[    1.944031] APIC frequency too slow, disabling apic timer
> 
> On cold boots it may see 12.5MHz, or may not...
> 
> [    2.000584] Using local APIC timer interrupts.
> [    2.004067] APIC timer calibration result 12500236
> [    2.004080] Detected 12.500 MHz APIC timer.
> 
> I haven't figured out yet what the pattern is behind the behavior. Has anyone
> else seen this kind of problem before?

Hmm, strange. Which kernel version ? 

Thanks,

	tglx
