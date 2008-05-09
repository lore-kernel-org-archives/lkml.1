Return-Path: <linux-kernel-owner+w=401wt.eu-S1763896AbYEITCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763896AbYEITCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYEITB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:01:57 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:40475 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYEITB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:01:57 -0400
Message-ID: <482491D6.9030205@grupopie.com>
Date: Fri, 09 May 2008 19:03:02 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
References: <20080509174148.GA22246@basil.nowhere.org>
In-Reply-To: <20080509174148.GA22246@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Haven't investigated why yet, but this doesn't seem right:
> 
> # cat /proc/kallsyms 
> 0000000000000b0c N DW.aio.h.903a6d92.0
> 0000000000000b19 N DW.aio.h.903a6d92.1
> 0000000000000b24 N DW.aio.h.903a6d92.2
> 0000000000000bce N DW.task_io_accounting.h.8d8de327.0
> 0000000000000bec N DW.hrtimer.h.c23659c6.0
> 0000000000000bf5 N DW.hrtimer.h.c23659c6.1
> 0000000000000c00 N DW.hrtimer.h.c23659c6.2
> 0000000000000c06 N DW.hrtimer.h.c23659c6.3
> 0000000000000c28 N DW.hrtimer.h.c23659c6.4
> 0000000000000c2e N DW.hrtimer.h.c23659c6.5
> ...
> ffffffff80337043 u idr_pre_get  [i2c_core]
> ffffc2000007573e ? DW.sched.h.920090ff.56       [i2c_core]

Are you compiling with CONFIG_KALLSYMS_ALL?

If you are, kallsyms will store all the output of "nm -n vmlinux" no 
matter what section the symbol belongs to...

-- 
Paulo Marques - www.grupopie.com

"C++ : increment the value of C and use the old one"
