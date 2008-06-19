Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYFSGaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYFSGaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYFSG3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:29:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47591 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbYFSG3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:29:53 -0400
Message-ID: <4859FCA4.4050606@zytor.com>
Date: Wed, 18 Jun 2008 23:28:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
References: <200805041823.57198.yhlu.kernel@gmail.com>	 <200805191252.36814.yhlu.kernel@gmail.com>	 <200805251600.26325.yhlu.kernel@gmail.com>	 <200806011317.38622.yhlu.kernel@gmail.com>	 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>	 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>	 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>	 <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>	 <alpine.LFD.1.10.0806190113290.3613@localhost.localdomain> <86802c440806182326m8c3ad56j29242895507e074d@mail.gmail.com>
In-Reply-To: <86802c440806182326m8c3ad56j29242895507e074d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> Can somebody clue me into why this concept
>> is something other than totally insane?
> 
> for system that have 6 pcie slots and more, with full populated cards.
> when boot with mptable, BIOS will use irq < 16 for all pci devices,
> and several devices will share same irq.
> but when acpi is enabled, irqs are spanned all over.
> 
> also when pci card with several pci bridges is plugged in, the mptable
> is totally messed up, some slot will work, and some doesn't work.

And the reason to worry about supporting non-ACPI on such hardware is what?

	-hpa
