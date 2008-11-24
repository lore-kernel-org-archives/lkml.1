Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYKXSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYKXSSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbYKXSSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:18:09 -0500
Received: from www.tglx.de ([62.245.132.106]:49885 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYKXSSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:18:07 -0500
Date: Mon, 24 Nov 2008 19:17:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       venkatesh.pallipadi@intel.com, shaohua.li@intel.com
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
In-Reply-To: <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain>
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com> <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Alexander Beregalov wrote:

> 2008/11/24 Alexander Beregalov <a.beregalov@gmail.com>:
> > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> > ODEBUG: object is on stack, but not annotated
> > ------------[ cut here ]------------
> > WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2a4/0x352()
> 
> Bisected down to 26afe5f2fbf06ea0765aaa316640c4dd472310c0
> (x86: HPET_MSI Initialise per-cpu HPET timers)
> 
> Revert helps

That's just a warning about a missing annotation. The commit is fine.

Thanks,

	tglx
