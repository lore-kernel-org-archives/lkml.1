Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbYKXJdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbYKXJdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYKXJdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:33:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:36599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYKXJdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:33:03 -0500
From: Andreas Schwab <schwab@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] __used is needed for function referenced only from inline asm
References: <1227514662-10848-1-git-send-email-edwintorok@gmail.com>
	<Pine.LNX.4.64.0811240948130.30025@anakin>
	<873ahhiil1.fsf@basil.nowhere.org>
X-Yow: All this time I've been VIEWING a RUSSIAN MIDGET SODOMIZE a HOUSECAT!
Date: Mon, 24 Nov 2008 10:32:54 +0100
In-Reply-To: <873ahhiil1.fsf@basil.nowhere.org> (Andi Kleen's message of "Mon,
	24 Nov 2008 10:22:50 +0100")
Message-ID: <je7i6twjsp.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>>>   */
>>> -static void noinline __sched
>>> +static __used noinline void __sched
>>
>> Perhaps we should incorporate it into `noinline'?
>
> No, we use noinline for other reasons too. Perhaps the other way
> around though.

Or just drop noinline here (since there are no callers to inline into
anyway).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
