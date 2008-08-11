Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYHKQj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYHKQj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYHKQjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:39:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbYHKQjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:39:11 -0400
Date: Mon, 11 Aug 2008 18:38:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@osdl.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811163855.GE4524@elte.hu>
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A05E79.4030304@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Rene Herman <rene.herman@keyaccess.nl> wrote:

>> The way to make the printout depend on apic=debug/verbose is to do 
>> something like this:
>>
>> 	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n", bp, length);
>>
>> Would you mind to send a patch for that?
>
> I wouldn't. Like this? This turns the printk's that used to be 
> Dprintk's into apic_printk's.

applied to tip/x86/urgent - thanks Rene.

> I am myself only interested in the one at the top of smp_scan_config() 
> (it made me think I had misconfigured something upon all of a sudden 
> seeing SMP printk's on my UP machine on 2.6.27-rc) but I guess this is 
> the more complete version.
>
> One problem; on 32-bit, "apic=" is a __setup() param and isn't 
> actually early enough for us here so this needs it turned into an 
> early_param() (followup).

good spotting, applied that one to tip/x86/urgent as well - thanks.

	Ingo
