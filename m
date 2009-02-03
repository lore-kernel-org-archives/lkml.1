Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZBCRge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZBCRge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZBCRgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:36:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZBCRgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:36:25 -0500
Date: Tue, 3 Feb 2009 18:36:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: fix 32-bit build resulting from mmu move
Message-ID: <20090203173612.GA3528@elte.hu>
References: <49876C6E.3010809@goop.org> <20090203122112.GD19979@elte.hu> <49887B79.4040708@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49887B79.4040708@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>> Moving the mmu code from enlighten.c to mmu.c inadvertently broke the
>>> 32-bit build.  Fix it.
>>>
>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>> ---
>>> arch/x86/xen/mmu.c |   37 +++++++++++++++++++++++++++++++++++++
>>> 1 file changed, 37 insertions(+)
>>>     
>>
>> that goes on top of the recent tip/x86/paravirt changes, right? No  
>> objections, i'm wondering why my testing didnt find any build breakage. 
>> Could you send me a .config that triggers the breakage?
>
> Any x86-32 + Xen build would hit it. +highmem+highpte would break a bit 
> more.

i have a lot of successful builds with that pattern, that's why i asked for 
a specific config from you that definitely triggers it - i'd like to 
investigate how it escaped my testing procedures.

	Ingo
