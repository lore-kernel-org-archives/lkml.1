Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYDGWCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYDGWCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYDGWCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:02:40 -0400
Received: from [88.44.63.6] ([88.44.63.6]:50442 "EHLO smtp-out04.alice-dsl.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbYDGWCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:02:39 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
From: Andi Kleen <andi@firstfloor.org>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
	<Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz>
Date: Tue, 08 Apr 2008 00:02:17 +0200
In-Reply-To: <Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz> (Jiri Kosina's message of "Mon, 7 Apr 2008 23:54:06 +0200 (CEST)")
Message-ID: <87abk5qq6u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Apr 2008 21:55:34.0370 (UTC) FILETIME=[1B158420:01C898FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:
>
> It is not safe to call smp_processor_id() in cases we are not sure someone 
> will not reschedule us.

We are sure. Machine checks always run with interrupts off.

Also BTW in a non preempt-rt kernel all exceptions run non preemptable
anyways.

-Andi
