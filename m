Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYH1UlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYH1UlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYH1UlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:41:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbYH1UlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:41:13 -0400
Date: Thu, 28 Aug 2008 13:40:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
In-Reply-To: <1219955655-18357-1-git-send-email-yhlu.kernel@gmail.com>
Message-ID: <alpine.LFD.1.10.0808281339250.3300@nehalem.linux-foundation.org>
References: <1219955655-18357-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Yinghai Lu wrote:
> 
> v2: insert e820 reserve resources before pnp_system_init

Looks ok by me. Now it just needs testing ;)

Does it actually fix the HPET regression on that odd machine (without the 
special hacks to recognize HPET explicitly)?

		Linus
