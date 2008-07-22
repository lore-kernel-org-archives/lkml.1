Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYGVV3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYGVV3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYGVV3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:29:31 -0400
Received: from 1wt.eu ([62.212.114.60]:1909 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYGVV3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:29:30 -0400
Date: Tue, 22 Jul 2008 23:29:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org, brice@myri.com
Subject: Re: Regression: myri10ge driver in 2.6.26
Message-ID: <20080722212921.GC29189@1wt.eu>
References: <20080722150438.GK4359@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080722150438.GK4359@ics.muni.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ linux-net and brice CCed ]

Not many changes since 2.6.25, but some seem to affect firmware part.
What was your last known working version ? Also, you appear not to be
using the firmware with 1.4.2, is there a specific reason ?

Willy

On Tue, Jul 22, 2008 at 05:04:38PM +0200, Lukas Hejtmanek wrote:
> Hello,
> 
> the myri10ge driver in 2.6.26 vanila kernel does not work.
> 
> Loading the driver produces only:
> [   86.641632] myri10ge: Version 1.3.99-1.347
> [   86.641632] PCI: Setting latency timer of device 0000:07:00.0 to 64
> 
> and nothing more.
> 
> The driver from Myricom web page version 1.4.2 works fine under the same
> kernel:
> [  664.668857] myri10ge: Version 1.4.2
> [  664.668857] PCI: Setting latency timer of device 0000:07:00.0 to 64
> [  664.675996] firmware: requesting myri10ge_eth_z8e.dat
> [  664.704897] myri10ge 0000:07:00.0: Unable to load myri10ge_eth_z8e.dat
> firmware image via hotplug
> [  664.704897] myri10ge 0000:07:00.0: hotplug firmware loading failed
> [  664.704897] myri10ge 0000:07:00.0: Successfully adopted running firmware
> [  664.704897] myri10ge 0000:07:00.0: Using firmware currently running on NIC.
> For optimal
> [  664.704897] myri10ge 0000:07:00.0: performance consider loading optimized
> firmware
> [  664.704897] myri10ge 0000:07:00.0: via hotplug
> [  664.754309] firmware: requesting adopted
> [  664.754896] myri10ge 0000:07:00.0: Unable to load adopted firmware image
> via hotplug
> [  664.754896] myri10ge 0000:07:00.0: hotplug firmware loading failed
> [  664.754896] myri10ge 0000:07:00.0: Successfully adopted running firmware
> [  664.828230] myri10ge 0000:07:00.0: MSI IRQ 499, tx bndry 2048, fw adopted,
> WC Enabled
> 
> 
> -- 
> Luká? Hejtmánek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
