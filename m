Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYF0QEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYF0QEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYF0QEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:04:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYF0QEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:04:06 -0400
Date: Fri, 27 Jun 2008 18:03:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080627160333.GA27072@elte.hu>
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863A8E6.1010807@goop.org>
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

>> plus -tip auto-testing found another build failure with:
>>
>>  http://redhat.com/~mingo/misc/config-Thu_Jun_26_12_46_46_CEST_2008.bad
>>
>> arch/x86/kernel/entry_64.S: Assembler messages:
>> arch/x86/kernel/entry_64.S:1201: Error: invalid character '_' in mnemonic
>> arch/x86/kernel/entry_64.S:1205: Error: invalid character '_' in mnemonic
>> arch/x86/kernel/entry_64.S:1209: Error: invalid character '_' in mnemonic
>> arch/x86/kernel/entry_64.S:1213: Error: invalid character '_' in mnemonic
>
> I'm confused.  How did this config both crash and not build?

this problem still reproduces.

i've pushed out all fixes into tip/x86/xen-64bit. That branch combined 
with the config above still reproduces the build failure above.

	Ingo
