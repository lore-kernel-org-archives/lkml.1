Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZCHVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZCHVXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZCHVXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:23:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:50691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZCHVXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:23:00 -0400
Message-ID: <49B436E4.1050103@kernel.org>
Date: Sun, 08 Mar 2009 14:21:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org> <20090308110437.GA27811@elte.hu> <20090308145803.GL25995@parisc-linux.org> <49B4330C.1060700@zytor.com> <49B4343B.9050807@kernel.org> <49B43585.2050606@zytor.com>
In-Reply-To: <49B43585.2050606@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>>> It's still generic PCI code, however.  If there is no host bridge
>>> exposed in PCI space, the patch is a noop.
>> ok, will split that patch to two
>> 1. one touch pci.c
>> 2. and one touch x86/pci.
>>
> 
> Speaking for myself, I don't see a reason to do that.  Just push the
> combined patch to Jesse.
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> ... if you need it.

thanks. 

Jesse or Matthew, can you pick this patch?

YH
