Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbYLHJz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbYLHJz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYLHJzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:55:51 -0500
Received: from mga07.intel.com ([143.182.124.22]:25269 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbYLHJzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:55:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,734,1220252400"; 
   d="scan'208";a="87638804"
Message-ID: <493CEF38.3060004@linux.intel.com>
Date: Mon, 08 Dec 2008 10:56:08 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Giangiacomo Mariotti <gg.mariotti@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>	 <493AE770.5030507@shaw.ca>	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>	 <493AF2EA.4030601@shaw.ca>	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>	 <493B4242.1040202@shaw.ca>	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>	 <20081207141337.588aede5@infradead.org>	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>	 <493CCFE4.2080802@jp.fujitsu.com> <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com> <493CEAA0.50201@jp.fujitsu.com>
In-Reply-To: <493CEAA0.50201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> IIRC, this error is not what happen on the time [301.7320xx] during
> boot, but happen before the boot.  Since the record says "Processor
> context corrupt," MCE handler should call panic(or do something stop
> the system) if the context actually corrupted during the boot.

The weird thing is that 301 seconds is quite a long delay for that.
It should happen  relatively quickly at boot as the CPUs are initialized.

> 
> In other words, it seems that 1) the error was recorded at last time
> when your machine crashed unexpectedly(by cosmic-ray etc.) and not cleared
> yet, or 2) your machine is doing something wrong in every reset/poweroff.

When it happens consistently at each boot then yes it's likely something
leaking from the BIOS initialization sequence. Perhaps try a BIOS update?

-Andi
