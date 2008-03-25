Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbYCYVKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbYCYVKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYCYVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:10:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYCYVKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:10:40 -0400
Message-ID: <47E96A29.4000503@redhat.com>
Date: Tue, 25 Mar 2008 18:10:01 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [PATCH 2/2] [PATCH] move apic declarations to mach_apic.h
References: <20080325150630.GA13828@elte.hu> <1206462537-8427-1-git-send-email-gcosta@redhat.com> <1206462537-8427-2-git-send-email-gcosta@redhat.com> <1206462537-8427-3-git-send-email-gcosta@redhat.com> <20080325195818.GA12302@elte.hu>
In-Reply-To: <20080325195818.GA12302@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Glauber Costa <gcosta@redhat.com> wrote:
> 
>> take them out of the x86_64-specific asm/mach_apic.h
> 
> this broke the 32-bit build:
> 
>  In file included from arch/x86/kernel/cpu/amd.c:8:
>  include/asm-x86/mach-default/mach_apic.h: In function 'init_apic_ldr':
>  include/asm-x86/mach-default/mach_apic.h:47: error: implicit declaration of function 'apic_write_around'
>  [...]
> 
> .config attached.
> 
> 	Ingo
> 
Problem is that local apic is not always present.
I'm sending a replacement.
