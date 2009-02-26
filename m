Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZBZIVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZBZIVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZBZIU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:20:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:32805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZBZIU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:20:58 -0500
Message-ID: <49A650B3.8080902@kernel.org>
Date: Thu, 26 Feb 2009 00:20:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove update_apic from x86_quirks
References: <49A61FA9.5080706@kernel.org> <20090226053254.GA11806@elte.hu> <20090226053426.GA23744@elte.hu> <20090226054305.GA13545@elte.hu>
In-Reply-To: <20090226054305.GA13545@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> except that it doesnt build:
> 
> arch/x86/kernel/built-in.o:(.data+0x8c08): undefined reference to `wakeup_secondary_cpu_via_init'
> arch/x86/kernel/built-in.o:(.data+0x8d68): undefined reference to `wakeup_secondary_cpu_via_init'
> arch/x86/kernel/built-in.o:(.data+0x8ec8): undefined reference to `wakeup_secondary_cpu_via_init'
> arch/x86/kernel/built-in.o:(.data+0x9038): undefined reference to `wakeup_secondary_cpu_via_init'
> 

.config?

I tested 32bit and 64bit

YH
