Return-Path: <linux-kernel-owner+w=401wt.eu-S2992678AbXDENXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992678AbXDENXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992600AbXDENXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:23:10 -0400
Received: from [216.54.166.4] ([216.54.166.4]:38244 "EHLO mx2.compro.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbXDENXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:23:08 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 09:23:07 EDT
X-IronPort-AV: i="4.14,377,1170651600"; 
   d="scan'208"; a="200196:sNHT24172790"
Message-ID: <4614F56D.5020704@compro.net>
Date: Thu, 05 Apr 2007 09:11:09 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IRQ splitting
References: <Pine.LNX.4.61.0704051231280.22282@yvahk01.tjqt.qr> <Pine.LNX.4.64.0704051412160.31796@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704051412160.31796@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 5 Apr 2007, Jan Engelhardt wrote:
> 
>> My question is whether it is possible that eth0's interrupts go to CPU0 
> 
> Documentation/IRQ-affinity.txt
> 

There is nothing in there tells ya how to get them off the same IRQ.
That has to be done first usually be moving one of them to another
slot/bus. Then Documentation/IRQ-affinity.txt can be referenced.

Somehow I think Jan already knew that and really wants to know
how to keep them from sharing the same irq without having to
change slot assignments. I know I would.

Mark
