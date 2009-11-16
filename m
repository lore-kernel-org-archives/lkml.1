Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZKPS5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZKPS5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZKPS47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:56:59 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:60871 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZKPS47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:56:59 -0500
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Brian Swetland <swetland@google.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2/3] msm: add minimal board file for HTC Dream device
References: <20091102104949.GA23456@elf.ucw.cz>
	<20091116163659.GB3568@n2100.arm.linux.org.uk>
	<a55d774e0911160843h22938604s8966a58ee71992a@mail.gmail.com>
	<20091116165716.GD3568@n2100.arm.linux.org.uk>
From: Robert Jarzmik <robert.jarzmik@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 16 Nov 2009 19:56:52 +0100
In-Reply-To: <20091116165716.GD3568@n2100.arm.linux.org.uk> (Russell King's message of "Mon\, 16 Nov 2009 16\:57\:16 +0000")
Message-ID: <87vdhagux7.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Mon, Nov 16, 2009 at 08:43:20AM -0800, Brian Swetland wrote:
>> What's the best way to handle a situation where there is no valid
>> debug uart?  Could the arch/platform require DEBUG_LL be unset via
>> Kconfig directives if it is configured in a way where there is no
>> valid debug uart?
>
> You're the first to have that issue.  Everyone else has a UART they
> can always direct stuff at.

Just for the record, there are machine files without a debug UART, especially in
the smartphone area.

In the PXA subworld I know, the UARTs are often used for :
 - a GSM chip (pxa ffuart)
 - a Bluetooth chip (pxa btuart)
 - a GPS chip (pxa stuart / hwuart)
 - an IR chip (pxa stuart / hwuart)

I didn't check through the mach-pxa/*.c, but mioa701.c accounts for one, and I
think magician and hx4700 would be part of it too. That also means kernel
debugging is _really_ painfull for these platforms.

Cheers.

--
Robert
