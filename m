Return-Path: <linux-kernel-owner+w=401wt.eu-S934938AbXHGQ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbXHGQ0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 12:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXHGQ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 12:26:06 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:2054 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXHGQ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 12:26:05 -0400
Message-ID: <46B89D5D.9090506@genesi-usa.com>
Date: Tue, 07 Aug 2007 17:27:09 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alan Curry <pacman@theworld.com>
CC: Segher Boessenkool <segher@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
References: <200708070416.l774G3Qf728075@shell01.TheWorld.com>
In-Reply-To: <200708070416.l774G3Qf728075@shell01.TheWorld.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Okay, you don't need to be an experienced Open Firmware developer.

In fact I know we have had experienced Open Firmware developers who have
said that our firmware sucks (some comment about "shitty German engineering",
I really did quit caring after that point) because they could not run probe-all
from the "ok" prompt.

In the first few pages of the OF spec, it very clearly states that this will
probably make your system explode.

So even experts do not know what they are doing. I don't expect users to.
But as an engineer, here, I think patching the device-type in the boot
wrapper (be it the chrp boot loader) is the wrong place, because we have
had real experts here (Ben, Segher etc.) complain that fixing the device
tree in the boot wrapper is no substitute for a correctly working
firmware.

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations

Alan Curry wrote:
> I'm almost sorry I spoke up...
> 
> Matt Sealey writes the following:
>> Okay before you add to the nvramrc you also need to add probe-all to build the
>> device tree first; I assumed this was common knowledge.
> 
> Maybe for experienced OpenFirmware developers; this is the first time I've
> had to touch the stuff. So first I had to learn Forth. To patch the kernel
> you only need to know C. (Of course I already knew C -- it's common
> knowledge.)
> 
