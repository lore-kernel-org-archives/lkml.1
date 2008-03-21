Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYCUNSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYCUNSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYCUNRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:17:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbYCUNRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:17:51 -0400
Date: Fri, 21 Mar 2008 14:17:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080321131738.GI27245@elte.hu>
References: <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu> <47E19085.2020308@goop.org> <20080319235212.GA22786@elte.hu> <47E2C7E3.40109@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E2C7E3.40109@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> so either figure out the bug by review or try turning your IRQ#0 into 
>> a screaming one for debug purposes. (hint: turning irq#0's trigger 
>> mode from 'edge' to 'level' in mpparse.c or ioapic.c does wonders to 
>> that end ;-)
>
> Hm.  I think the problem was that the patch changed the ordering so 
> that the %ebp fault test was happening with interrupts disabled, 
> meaning that any fault-in would happen with interrupts disabled.
>
> Could you tell me if this revised patch still provokes a problem?

it's looking good so far - queued it up.

	Ingo
