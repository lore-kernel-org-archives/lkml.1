Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbXLRE6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbXLRE6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXLRE5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:57:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXLRE5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:57:45 -0500
Message-ID: <476751EF.3090601@zytor.com>
Date: Mon, 17 Dec 2007 20:51:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@muc.de>, Paul Mackerras <paulus@samba.org>,
       Greg KH <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       venkatesh.pallipadi@intel.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
References: <20071213235543.568682000@intel.com>	<20071213235712.813201000@intel.com> <20071214001932.GA10389@suse.de>	<20071213.163505.14070110.davem@davemloft.net>	<20071214063424.GB10100@suse.de>	<18277.40798.828760.919571@cargo.ozlabs.ibm.com>	<20071217124137.GA18648@muc.de> <m1ejdkd3qk.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejdkd3qk.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> 0000_00FD_FC00_0000h - 0000_00FD_FDFF_FFFFh On a hypertransport based
> system should work.  There is a 32MB window for it.
> 

It doesn't.  The termination on MMIO and IOIO transaction is different, 
and poking this memory window with an MMIO transaction will lock the 
chipset hard (yes, I've tried it.)

	-hpa
