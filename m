Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXJ2MnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXJ2MnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbXJ2Mmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:42:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:60991 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXJ2Mmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:42:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AMckyQxXG640FaG0MWugDahGcGUAV5iX/HVwi0lFiQy8t57K/VgRUCJLhADCLF/9rygI3EhCAautSVA5cQKTVTlnPmq8X+9Ukrfq1TaxaYUG++J/LDJXrPrI+6uaQ2PRWosXsrqdkGrsszBbrrD/3XOvukDrJnAxWmdsUloCZ8E=
Message-ID: <4725D527.8030909@googlemail.com>
Date: Mon, 29 Oct 2007 13:42:15 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
References: <200710290628.l9T6SDpo012530@harpo.it.uu.se>
In-Reply-To: <200710290628.l9T6SDpo012530@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> On Sun, 28 Oct 2007 21:33:02 -0700, H. Peter Anvin wrote:
>> Mikael Pettersson wrote:
>>> My old 486 fails to boot with the 2.6.24-rc1 kernel.
>>> Grub loads it, 4 lines of text appear but not the kernel's
>>> "Linux version <blah> greet", and the machine reboots.
>>> Double-checked with a serial console: nothing appears
>>> before it reboots.
>> What four lines of text?
> 
> They're impossible to capture because they're only visible
> on the VGA screen for like 0.2 seconds before the machine
> reboots and the screen is blanked; they don't show up on
> the serial console.

Maybe try to set CONFIG_BOOT_PRINTK_DELAY and boot with boot_delay=N ?

> 
> They look like paths to the vmlinuz and initrd surrounded
> by [ ] brackets, so I guess they come from grub.
> 
> /Mikael


Regards,

Gabriel
