Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZDRWiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZDRWiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 18:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZDRWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 18:37:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbZDRWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 18:37:51 -0400
Date: Sat, 18 Apr 2009 15:31:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
In-Reply-To: <49EA2983.3070003@kernel.org>
Message-ID: <alpine.LFD.2.00.0904181530290.2199@localhost.localdomain>
References: <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org>
 <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <20090418092216.GP7678@elte.hu> <alpine.LFD.2.00.0904181151230.4042@localhost.localdomain> <20090418191425.GA19565@elte.hu> <49EA2983.3070003@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Yinghai Lu wrote:
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>

This is _not_ my patch, and I think this is wrong.

My patch was about adding entries to the resource region. I very much said 
that I do _not_ like your approach of editing the e820 memory map itself.

I think this patch is horrible, and NAK it, and definitely don't want my 
name on it.

		Linus
