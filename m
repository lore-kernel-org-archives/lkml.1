Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYKSVPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYKSVPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYKSVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:15:06 -0500
Received: from www.tglx.de ([62.245.132.106]:52469 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYKSVPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:15:05 -0500
Date: Wed, 19 Nov 2008 13:14:37 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mingo@elte.hu
Subject: Re: next-20081119: general protection fault:
 get_next_timer_interrupt()
In-Reply-To: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Wed, 19 Nov 2008, Alexander Beregalov wrote:
> 
> It is 4way X86_64
> The kernel does not boot.
 
> RIP: 0010:[<ffffffff80240061>]  [<ffffffff80240061>]
> get_next_timer_interrupt+0x11b/0x1f0

Can you please enable:

CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=Y

and add "debug_objects" to the kernel command line ?

Thanks,

	tglx

