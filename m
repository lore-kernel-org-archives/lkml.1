Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYKWUOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYKWUOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYKWUOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:14:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYKWUOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:14:06 -0500
Message-ID: <4929B95E.4@zytor.com>
Date: Sun, 23 Nov 2008 12:13:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Jan Beulich <jbeulich@novell.com>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] x86: include ENTRY/END in entry handlers in entry_64.S
References: <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123092136.GC24818@localhost> <20081123112354.GA31667@mailshack.com>
In-Reply-To: <20081123112354.GA31667@mailshack.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> I put a ".p2align 5" in earlier in the series which caused the
> apicinterrupts to be 32-byte aligned. But it is a hack, really,
> relying on the generated code per stub to be between 17 and 32
> bytes, on the default alignment to be 16 bytes and all stubs
> to be in the .text section.
> 
> I'm in favour of aligning all of the interrupt/exception stubs
> to 32 bytes, but it should be implemented the right way ;),
> which means that we need KPROBE_ENTRY_P5ALIGNED and so on :-/.
> 

I'm sorry, I really don't follow that logic at all.  Why the heck would
KPROBE_ENTRY_P5ALIGNED be better than .p5align?

For the record, I think we already have way to much macro crappage.  It
makes the code painful to read and hard to figure out what the real
constraints on it is.

	-hpa
