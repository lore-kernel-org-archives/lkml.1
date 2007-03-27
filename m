Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbXC0PRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbXC0PRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXC0PRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:17:23 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:53803 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbXC0PRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:17:23 -0400
Message-ID: <46093566.4040902@free.fr>
Date: Tue, 27 Mar 2007 17:16:54 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: John <linux.kernel@free.fr>
CC: linux-kernel@vger.kernel.org, tglx@timesys.com, mingo@elte.hu,
       johnstul@us.ibm.com, akpm@osdl.org, linux.kernel@free.fr
Subject: Re: 2.6.20.3-rt8 clock_nanosleep() sleeps 10 ms
References: <460930BB.2050905@free.fr>
In-Reply-To: <460930BB.2050905@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John wrote:

> It seems the CPU was not switched to high-resolution mode?
> 
> # dmesg | grep resolution
> /* NOTHING */
> 
> Do I need to enable ACPI?

ACPI seems mandatory for high-resolution mode?

I added...

CONFIG_ACPI=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y

# dmesg | grep resolution
Switched to high resolution mode on CPU 0

Ingo, Thomas, do you have time to explain why ACPI is needed?

Regards.
