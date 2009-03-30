Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZC3PAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZC3PAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZC3PAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:00:06 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:5661 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZC3PAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:00:04 -0400
Message-ID: <49D0DE6F.4000400@turknet.net.tr>
Date: Mon, 30 Mar 2009 17:59:59 +0300
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090227 Shredder/3.0b2
MIME-Version: 1.0
To: Subrata Modak <tosubrata@gmail.com>
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: Linux-2.6.29-git6 Compile Error
References: <49D0D3DF.1050008@turknet.net.tr> <bb33bcf20903300748i66eec692hf9ba571758ebc29@mail.gmail.com>
In-Reply-To: <bb33bcf20903300748i66eec692hf9ba571758ebc29@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2009 15:00:00.0104 (UTC) FILETIME=[32933680:01C9B148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2009 05:48 PM, Subrata Modak wrote:
> Hi
Hi Subrata,
> ,
> This is declared here:
>
> ./arch/x86/include/asm/timer.h:14:extern int recalibrate_cpu_khz(void);
>
> I do not have access to git6. Can you please see whether this is 
> included in code for:
> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
>

When searched "recalibrate_cpu_khz", it's included. But not "extern int 
recalibrate_cpu_khz"

root@tarkane:/usr/src/linux-2.6.29# grep -i "extern int 
recalibrate_cpu_khz" arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
root@tarkane:/usr/src/linux-2.6.29# grep -i -A 1 -B 1 
"recalibrate_cpu_khz" arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
                 cpufreq_p4_setdc(policy->cpu, DC_DISABLE);
                 recalibrate_cpu_khz();
         }
root@tarkane:/usr/src/linux-2.6.29#


---
Tarkan

