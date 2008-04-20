Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYDTVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYDTVlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYDTVlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:41:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37064 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYDTVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:41:04 -0400
Message-ID: <480BB85A.6020508@firstfloor.org>
Date: Sun, 20 Apr 2008 23:40:42 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Daniel Hazelton <dhazelton@enter.net>
CC: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080420114845.77bf3fed@laptopd505.fenrus.org> <480BA12A.4000307@firstfloor.org> <200804201643.35830.dhazelton@enter.net>
In-Reply-To: <200804201643.35830.dhazelton@enter.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton wrote:

> At 12 threads per request it'd only take about 4200 outstanding requests. That 
> is high, but I can see it happening.

If it happens it just won't work on 32bit.

> Just makes you sound foolish. Run the numbers yourself and you'll see that it 
> is easy for a machine running highly threaded code to easily hit 50K threads.

I ran the numbers and the numbers showed that you need > 1.5GB of lowmem
with a somewhat realistic scenario (32K per thread) at 50k threads. And
subtracting 4k from that 32k number won't make any significant
difference (still 1.3GB)

If you claim that works on a 32bit system with typically 300-600MB
lowmem available (which is also shared by other subsystem) I know who
sounds foolish.

-Andi
