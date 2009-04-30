Return-Path: <linux-kernel-owner+w=401wt.eu-S1764193AbZD3SYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764193AbZD3SYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZD3SYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:24:24 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:43893 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbZD3SYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:24:24 -0400
Subject: Re: Default HZ value for X86
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1240873630.14713.25.camel@alok-dev1>
References: <1240873630.14713.25.camel@alok-dev1>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 30 Apr 2009 11:24:24 -0700
Message-Id: <1241115864.23703.4.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-04-27 at 16:07 -0700, Alok Kataria wrote:
> Hi, 
> 
> I was wondering why do we still have the default HZ value as 1000 for
> the x86 kernels.
> 
> arch/x86/configs/i386_defconfig:CONFIG_HZ=1000
> arch/x86/configs/x86_64_defconfig:CONFIG_HZ=1000
> 
Ingo/Thomas,

I noticed that the default HZ value was switched back to 1000 (from 250)
about an year back. The commit log didn't have any details about the
switch, and I was wondering what prompted that change ?

-------------------------------------------------------------------------
commit 5cb04df8d3f03e37a19f2502591a84156be71772
    x86: defconfig updates

    refresh 32-bit defconfig too, and update the 64-bit configs as well,
    the defconfig should be much more useful by default, so most of the
    updates are the enabling of various options.
-------------------------------------------------------------------------

Thanks,
Alok

