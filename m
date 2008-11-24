Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYKXJW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYKXJW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYKXJWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:22:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35720 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYKXJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:22:51 -0500
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?utf-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] __used is needed for function referenced only from inline asm
From: Andi Kleen <andi@firstfloor.org>
References: <1227514662-10848-1-git-send-email-edwintorok@gmail.com>
	<Pine.LNX.4.64.0811240948130.30025@anakin>
Date: Mon, 24 Nov 2008 10:22:50 +0100
In-Reply-To: <Pine.LNX.4.64.0811240948130.30025@anakin> (Geert Uytterhoeven's message of "Mon, 24 Nov 2008 09:57:20 +0100 (CET)")
Message-ID: <873ahhiil1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:
>>   */
>> -static void noinline __sched
>> +static __used noinline void __sched
>
> Perhaps we should incorporate it into `noinline'?

No, we use noinline for other reasons too. Perhaps the other way
around though.

-Andi

-- 
ak@linux.intel.com
