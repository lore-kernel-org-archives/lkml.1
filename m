Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0AOIH6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146Ab0AOIH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:07:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:25268 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0AOIH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:07:56 -0500
Message-ID: <4B5021F8.4010703@monstr.eu>
Date: Fri, 15 Jan 2010 09:06:16 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, x86@kernel.org, mingo@redhat.com,
        tglx@linutronix.de, lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH] cpuinfo_op: consolidate extern declaration
References: <201001141158.09795.hartleys@visionengravers.com>
In-Reply-To: <201001141158.09795.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> cpuinfo_op: consolidate extern declaration
> 
> All the architectures supported by the kernel also support
> /proc/cpuinfo. Only a couple actually declare the seq_operations
> as extern. All the others will produce a sparse warning like:
> 
> warning: symbol 'cpuinfo_op' was not declared. Should it be static?
> 
> Fix all the warnings and consolidate the declaration by putting it
> in <linux/seq_file.h>.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> 

Tested-by: Michal Simek <monstr@monstr.eu>


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
