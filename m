Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbZE0HWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbZE0HWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbZE0HRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:51 -0400
Received: from claw.goop.org ([74.207.240.146]:41520 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760836AbZE0HRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:50 -0400
Message-ID: <4A1CE907.2080601@goop.org>
Date: Wed, 27 May 2009 00:17:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Greg KH <gregkh@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 02/17] x86: add io_apic_ops to allow interception
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <1242170724-13349-3-git-send-email-jeremy@goop.org> <20090525035446.GC9396@elte.hu>
In-Reply-To: <20090525035446.GC9396@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok, could you please turn the whole IO-APIC code into a driver 
> framework? I.e. all IO-APIC calls outside of 
> arch/x86/kernel/apic/io_apic.c should be to some io_apic-> method.
>
> The advantage will be a proper abstraction for all IO-APIC details - 
> not just a minimalistic one for Xen's need.
>
> Also, please name it 'struct io_apic' - similar to the 'struct apic' 
> naming we have for the local APIC driver structure.

OK, I'll have a look at it.  I think it could turn out quite nicely, and 
possibly remove the need for some other other Xen hooks around the 
place, as well as make the path for some other other upcoming things 
clearer.

But in the meantime, would you consider taking the minimal ops approach 
for this next merge window, and the full api in the next dev cycle?

Thanks,
    J

