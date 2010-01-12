Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721Ab0ALDRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0ALDRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340Ab0ALDRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:17:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab0ALDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:17:49 -0500
Date: Mon, 11 Jan 2010 19:16:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] x86: using logical flat for amd cpu too.
In-Reply-To: <1263264483-3959-2-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1001111913570.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org> <1263264483-3959-2-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Jan 2010, Yinghai Lu wrote:
> 
> tested that amd support logical flat too when cpus num <= 8 and even
> bsp apic id > 8
> 
> so could remove vendor check...

At least this one makes code simpler.

What was the background for thinking that AMD didn't support the same APIC 
addressing models? If there really is some issue external to the CPU's 
themselves, whatever problem was attributed to AMD might be the same (or 
similar) problem that Ananth had.

		Linus
