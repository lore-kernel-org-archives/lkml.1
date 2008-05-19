Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYESMxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYESMxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYESMxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:53:47 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:60516 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYESMxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:53:46 -0400
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I/O APIC: Timer through 8259A revamp
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl>
Date: Mon, 19 May 2008 14:52:01 +0200
In-Reply-To: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl> (Maciej W. Rozycki's message of "Sun, 18 May 2008 04:35:54 +0100 (BST)")
Message-ID: <87hccubgni.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 May 2008 12:44:58.0861 (UTC) FILETIME=[25BC61D0:01C8B9AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Maciej W. Rozycki" <macro@linux-mips.org> writes:
> ---
>  It works for my system, but it definitely requires much, much more
> testing.  The patch depends on patch-2.6.26-rc1-20080505-timer_ack-1 sent
> earlier.

I tried to clean up this code in the past too, but one experience I got
was that even a lot of relatively modern systems (<5 years old) fall into the fallback
paths unfortunately and it's quite difficult to find out why.

Also Windows uses a different timer set up so this configuration is often
not well tested.

-Andi
