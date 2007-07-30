Return-Path: <linux-kernel-owner+w=401wt.eu-S939761AbXG3UQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939761AbXG3UQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935609AbXG3UQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:16:03 -0400
Received: from keil-draco.com ([216.193.185.50]:50423 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763200AbXG3UQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:16:00 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Bernhard Kaindl <bk@suse.de>
Subject: Re: Ok, lets kill the 'PCI hidden behind bridge' message (was: pci=assign-busses)
Date: Mon, 30 Jul 2007 16:15:44 -0400
User-Agent: KMail/1.9.6
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Adrian Bunk <bunk@stusta.de>,
       Alois =?utf-8?q?Ne=C5=A1por?= <alois.nespor@gmail.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de
References: <6c9774880707300129if10dbf4n25c5077f02c940e3@mail.gmail.com> <20070730115331.GO16817@stusta.de> <Pine.LNX.4.64.0707301932440.25292@jbgna.fhfr.qr>
In-Reply-To: <Pine.LNX.4.64.0707301932440.25292@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707301615.44992.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2007 14:35:13 Bernhard Kaindl wrote:
<snip>
> Ok, lets kill the message. As Alois Nešpor also saw, that's fixed up by
> Yenta, so PCI does not have to warn about it. PCI could still warn about it
> if is_cardbus is 0 in that instance of pci_scan_bridge(), but so far I have
> not seen a report where this would have been the case so I think we can
> spare the kernel of that check (removes ~300 lines of asm) unless debugging
> is done.
>
> History: The whole check was added in the days before we had the fixup
> for this in Yenta and pci=assign-busses was the only way to get CardBus
> cards detected on many (not all) of the machines which give this warning.

The message triggers on systems without Cardbus at all.

> In theory, there could be cases when this warning would be triggered and
> it's not cardbus, then the warning should still apply, but I think this
> should only be the case when working on a completely broken PCI setup,
> but one may have already enabled the debug code in drivers/pci and the
> patched check would then trigger.

I wouldn't say totally broken. The last 5 computers I've owned have had this 
message. On only one could it even *remotely* be related to CardBus (my one 
year old laptop), and on one of them it does create problems for certain 
(NVidia) binary drivers. (and then pci=assign-busses doesn't do jack to clear 
the message)

I'm not saying that binary drivers shouldn't be broken - but...
<snip>


DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
