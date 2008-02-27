Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYB0SPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYB0SPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYB0SPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:15:09 -0500
Received: from www.tglx.de ([62.245.132.106]:52742 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYB0SPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:15:08 -0500
Date: Wed, 27 Feb 2008 19:14:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <rdreier@cisco.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
In-Reply-To: <adad4qiwcmz.fsf@cisco.com>
Message-ID: <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
References: <adad4qiwcmz.fsf@cisco.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Roland Dreier wrote:
> With an up-to-date git tree (head 7704a8b6) I'm seeing the oops below
> when the hpwdt driver gets loaded during boot on an HP DL380 system.
> I don't think I've seen any previous reports of this, and I guess it
> doesn't really count as a regression since the hpwdt driver was only
> added after 2.6.25-rc2.
> 
> I haven't tried to debug this at all yet but any guidance about what
> information is useful for what looks to be an issue with c_p_a would
> be appreciated.
> 
>  BUG: unable to handle kernel paging request at ffffc20001a08000
>  IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
>  PGD 1bf80e067 PUD 1bf80f067 PMD 1bb1ab067 PTE 80000047000ee17b

-------------------------------------------------^^^^^^^^^^^^^^^^

The physical address looks strange: 0x47000EE000

Can you provide a full boot log please ?

Thanks,
	tglx
