Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbYHFDy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbYHFDy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYHFDyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:54:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22093 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYHFDyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:54:47 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5354"; a="5180698"
Message-ID: <48992085.3050203@qualcomm.com>
Date: Tue, 05 Aug 2008 20:54:45 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>	 <48991B07.3050500@qualcomm.com> <b6a2187b0808052050h35e2786fwfbf1e1dd5c37d8cf@mail.gmail.com>
In-Reply-To: <b6a2187b0808052050h35e2786fwfbf1e1dd5c37d8cf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Wed, Aug 6, 2008 at 11:31 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> You could try booting CONFIG_NR_CPUS=16 with maxcpus=8 (kernel command line option).
>> If it boots you can then try bringing the rest of the cpus online manually
> 
> Ok,  booted with CONFIG_NR_CPUS=16 with maxcpus=8, but can't find the
> rest of the CPUs.
> 
> I can only find cpu0 to cpu7 ...
> 
> 
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu0
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu1
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu2
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu3
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu4
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu5
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu6
> drwxr-xr-x  4 root root    0 Aug  6 19:38 cpu7
> -r--r--r--  1 root root 4096 Aug  6 19:41 online
> -r--r--r--  1 root root 4096 Aug  6 19:39 possible
> -r--r--r--  1 root root 4096 Aug  6 19:38 present
> -rw-r--r--  1 root root 4096 Aug  6 19:38 sched_mc_power_savings
> 
> # cat online
> 0-7
> # cat possible
> 0-23
> # cat present
> 0-7

Are you running 32-bit kernel ?

Max


