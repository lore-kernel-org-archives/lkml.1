Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbZAWEOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbZAWEOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 23:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZAWEOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 23:14:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:39472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbZAWEOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 23:14:35 -0500
Message-ID: <49794422.2080109@kernel.org>
Date: Fri, 23 Jan 2009 13:14:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory
 	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
References: <49763718.7010501@kernel.org> <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>
In-Reply-To: <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 23 Jan 2009 04:14:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Jan 20, 2009 at 12:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> with the config
>>
>> current tip said:
>>
>>  RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>> WARNING: Absolute relocations present
>> Offset     Info     Type     Sym.Value Sym.Name
>> c14d2186 00920e01   R_386_32 c1514000  __per_cpu_load
>>
> and will casue system reboot after
> 
> [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Allocating 36864 bytes of per cpu dat

Can you please try the current core/percpu branch?  I tried your
config but the problem doesn't happen here.

Thanks.

-- 
tejun
