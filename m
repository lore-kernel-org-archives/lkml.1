Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844Ab0ALDWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0ALDWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685Ab0ALDWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:22:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab0ALDWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:22:50 -0500
Date: Mon, 11 Jan 2010 19:20:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] x86: according to nr_cpu_ids to decide if need
 to leave logical flat
In-Reply-To: <1263264483-3959-3-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1001111917190.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org> <1263264483-3959-3-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Jan 2010, Yinghai Lu wrote:
> +
> +void default_setup_apic_routing(void)

Good cleanup, makes x86-64 and x86-32 look similar. However, you should 
mark it __init too, I think, to match the current probe_64.c thing.

Also, what about the default_setup_apic_routing() call in 
arch/x86/kernel/apic/apic.c? Is that not ripe for unification too now? You 
only did the smpboot.c one, not the APIC_init_uniprocessor() one.

Hmm?

		Linus
