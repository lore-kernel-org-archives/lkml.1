Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYEGObY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYEGObY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbYEGObK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:31:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33892 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYEGObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:31:09 -0400
Message-ID: <4821BD2A.3090000@firstfloor.org>
Date: Wed, 07 May 2008 16:31:06 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: stephane eranian <eranian@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Subject: Re: [PATCH] perfmon: add context switch hooks for x86
References: <7c86c4470805070133q29515056s386c137f644b7f3b@mail.gmail.com>	 <4821BA06.9020704@firstfloor.org> <7c86c4470805070724v793fbdcamf18579308a183a9d@mail.gmail.com>
In-Reply-To: <7c86c4470805070724v793fbdcamf18579308a183a9d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian wrote:
> Andi,
> 
> It would be much bigger because it would pull in a bunch of generic
> and model-specific
> data structures and code.
> 
> To context switch, you need to know what the registers are, thus you
> need the PMU
> mapping table, which is implemented by a kernel module, so it needs
> its registration
> framework....

Can you strip it down to be simpler?

Minimally generic x86 perfctr switching code just needs an array with
MSR numbers, doesn't it? And there are only a few variants.

-Andi
