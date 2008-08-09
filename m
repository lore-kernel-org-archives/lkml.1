Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYHIFP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYHIFP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 01:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYHIFPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 01:15:20 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:47325 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYHIFPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 01:15:19 -0400
Message-ID: <489D27F0.90609@keyaccess.nl>
Date: Sat, 09 Aug 2008 07:15:28 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, rene.herman@gmail.com
Subject: Re: + x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch added
 to -mm tree
References: <200808082051.m78KpZGC027833@imap1.linux-foundation.org>	 <86802c440808081413u2249fff1g1940ff472cdf10e7@mail.gmail.com>	 <20080808142847.9e4f33b2.akpm@linux-foundation.org> <86802c440808081444q45353d92xd2483f9bdfdf29c3@mail.gmail.com>
In-Reply-To: <86802c440808081444q45353d92xd2483f9bdfdf29c3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-08-08 23:44, Yinghai Lu wrote:

> On Fri, Aug 8, 2008 at 2:28 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Fri, 8 Aug 2008 14:13:29 -0700
>> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>>
>>>> commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly nopped
>>>> debugging printks in arch/x86/kernel/mppparse.c into regular ones.  The
>>>> one at the top of smp_scan_config() in particular also prints on
>>>> !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines without anything
>>>> resembling MP tables which makes their lowly UP owners wonder...
>>>>
>>>> Given that it was up to this point also not considered valuable user-level
>>>> information, let's just kill that one.
>>>>
>>> why?  that just three lines debug debug info.
>> For the reasons described in the changelog text.  They look quite valid
>> to me.
> 
> then how about system do have mptable ?

Those print:

   printk(KERN_INFO "found SMP MP-table at [%p] %08lx\n",
                                  mpf, virt_to_phys(mpf));

a few lines down. Note moreover that is used to be a "Dprintk()" which 
was defined to <nop> before -- ie, no change.

Rene.
