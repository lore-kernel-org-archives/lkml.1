Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbXJTBfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbXJTBfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbXJTBez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:34:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbXJTBey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:34:54 -0400
Message-ID: <47195B17.9070607@zytor.com>
Date: Fri, 19 Oct 2007 18:34:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jikos@jikos.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <Pine.LNX.4.64.0710192307320.18815@twin.jikos.cz> <47191F6C.2040801@googlemail.com> <47192E7D.7080409@googlemail.com> <alpine.LFD.0.9999.0710200048290.22770@localhost.localdomain> <47194132.7070905@googlemail.com>
In-Reply-To: <47194132.7070905@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> 
> Actually I try to get VirtualBox-1.5.2_OSE to compile but I get a lot errors from 
> include/asm-generic/atomic.h and other headers.
> 
> and looks like some are missing ?
> 
> /lib/modules/2.6.23-rc0/build/include/asm/irq_32.h:15:25: error: irq_vectors.h: No such file or directory
> /lib/modules/2.6.23-rc0/build/include/asm/smp_32.h:154:26: error: mach_apicdef.h: No such file or directory
> 

Those files are part of the machine subdirectories.  I will look at this 
tomorrow and try to figure out what doesn't get picked up.

	-hpa
