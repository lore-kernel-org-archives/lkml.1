Return-Path: <linux-kernel-owner+w=401wt.eu-S965308AbXAZNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308AbXAZNAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXAZNAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:00:47 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:61165 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbXAZNAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MOpmmDWvHGzfm/kKu39uE7N3GDILrpPfOoVIX5BJbal/DcNiyh5jsf+WR5lhv4QYecILLrf8KhNHGoHvsVvLHxaUQ1zLlS1XB7XLYR5KJlfLE9wzLUbqxUMnnq+mschftb1jvEEw9GIW70umgof6Mn+U6yaZEU57mkjJFj//SQQ=
Message-ID: <a37929f0701260500x68cf6bb0i8a5ef603794a861f@mail.gmail.com>
Date: Fri, 26 Jan 2007 14:00:45 +0100
From: "mirek kratochvil" <exa.exa@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: r8169 problems on x86_64 (transmit timeout & crash)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> In case you have BIOS 04.., try to upgrade to 06.. version. Also, does it
> help when you boot with acpi=off kernel commandline parameter? (do you
> compile kernel with both acpi and apic support?).
>
> Jiri Kosina
>

Upgraded to bios 0802,  but still the same problem. I think it's
definitely something
about the r8169 driver. acpi=off doesn't help. turning on/off apic
also doesn't matter.

What exactly means msg "Netdev watchdog: Transmit timed out" ? I hope
the broblem
is just about that tx (dying when transmitting...), because otherwise
I'd start suspecting
hardware. (note: full-speed receive doesn't crash anything)

one thing more - have confirmed that the bug is reproducible on *any*
laptop with 8168,
not only Asus. I guess the disk-usage-crash was some other bug.

I'm gonna ask some other people with 8168Realtek NICs to test this, hope some of
them can reproduce this and get better view of what's going on...

thanks
mirek kratochvil
