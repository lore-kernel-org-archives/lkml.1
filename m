Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXCYQnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXCYQnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXCYQnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:43:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36536 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXCYQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JpsYwDEI1NL8WzohMUKJ1utAVFZ/Jx4E/PRhnwDBiSJBQjvany2ElStscBRUiG9PU0vEPS0gqd/VpEILCnoHw7I83V+5QoKzs0tr+DFW/VIfERlziVAk/XC2cD/xFtCpk/6Cwx/tmyUhWLXQe43RHaU5j35qjaTMQZsuzBO/OFY=
Message-ID: <4606A6B0.4010601@googlemail.com>
Date: Sun, 25 Mar 2007 18:43:28 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070207)
MIME-Version: 1.0
To: "Kevin P. Fleming" <lkml@kpfleming.us>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust BAR0
 (not I/O)' on NVidia MCP51
References: <460693EB.9080203@kpfleming.us>
In-Reply-To: <460693EB.9080203@kpfleming.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin P. Fleming wrote:
> I just upgraded from 2.6.20.2 to 2.6.20.4 on my Compaq V6000 laptop,
> which has an NVidia core chipset. It has the MCP51 and uses it for PATA
> and SATA.
>
> Booting the 2.6.20.4 kernel causes two messages (and a kernel lockup)
> like this:
>
> 0000:00:0d.0: cannot adjust BAR0 (not I/O)
> 0000:00:0d.0: cannot adjust BAR1 (not I/O)
>   

BTW I see this too on my laptop ( older PackardBell EasyNote K ) if I 
use P-ATA but I can boot for some reason.


snip

...

[   18.754623] Enabling SiS 96x SMBus.
[   18.754812] 0000:00:02.5: cannot adjust BAR0 (not I/O)
[   18.754816] 0000:00:02.5: cannot adjust BAR1 (not I/O)
[   18.754819] 0000:00:02.5: cannot adjust BAR2 (not I/O)
[   18.754822] 0000:00:02.5: cannot adjust BAR3 (not I/O)

...



> Booting without ACPI, without APIC, without LAPIC makes no usable
> difference (although sometimes I will also receive a message about BAR2).
>
> This patch:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ed8ccee0918ad063a4741c0656fda783e02df627;hp=9e5755bce00bb563739aeb0f09932a1907521167
>
> is the cause... backing it out results in a working 2.6.20.4 kernel on
> my laptop.
>
> I'll be happy to provide any assistance I can debugging this problem.
> Thanks.
>   

Reagrds,

Gabriel

