Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbZANMqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbZANMqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbZANMqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:46:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:35626 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752886AbZANMqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:46:44 -0500
X-Authenticated: #6028172
X-Provags-ID: V01U2FsdGVkX18nHupUuVMn/ujz5zWns9pmevn38VTs+wj2jPo5UA
	NdxeZKomHdYiou
Message-ID: <496DDED0.9020004@gmx.de>
Date: Wed, 14 Jan 2009 13:47:12 +0100
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu> <200901141146.04563.rusty@rustcorp.com.au>
In-Reply-To: <200901141146.04563.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Rusty Russell schrieb:
> How about this instead of reverting?
> Rusty.
> 
> fix: use smp_call_function_single() not work_on_cpu in acpi-cpufreq.c
> 
> get_measured_perf() gets called through twisty chains, and
> work_on_cpu() has issues being called here as it takes the cpu hotplug
> lock.
> 
> So we just use smp_call_function_single() which should work fine for
> this case.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 


I just applied that patch and tried it, but it does not work. The
stacktrace seems to be the same as before, but I cannot say it 100% for
sure, as I dont have my netconsole machine here.

I can send the trace in the late afternoon, when I am home.


cu

Dieter
