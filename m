Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZISHrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZISHrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZISHrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:47:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZISHrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:47:03 -0400
Message-ID: <4AB48BAC.1000409@redhat.com>
Date: Sat, 19 Sep 2009 10:43:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
In-Reply-To: <1253233028.19731.63.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2009 03:17 AM, Alok Kataria wrote:
> Hi,
>
> We ran a few experiments to compare performance of VMware's
> paravirtualization technique (VMI) and hardware MMU technologies (HWMMU)
> on VMware's hypervisor.
>
> To give some background, VMI is VMware's paravirtualization
> specification which tries to optimize CPU and MMU operations of the
> guest operating system. For more information take a look at this
> http://www.vmware.com/interfaces/paravirtualization.html
>
> In most of the benchmarks, EPT/NPT (hwmmu) technologies are at par or
> provide better performance compared to VMI.
> The experiments included comparing performance across various micro and
> real world like benchmarks.
>    

We've reached a similar conclusion for kvm pvmmu vs ept/npt.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

