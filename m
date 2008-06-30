Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYF3IWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYF3IWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYF3IWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:22:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55765 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbYF3IWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:22:09 -0400
Date: Mon, 30 Jun 2008 10:21:35 +0200
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
Message-ID: <20080630082135.GA22844@elte.hu>
References: <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48684CD4.7040403@goop.org>
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
>> with this config:
>>
>>   http://redhat.com/~mingo/misc/config-Sun_Jun_29_10_29_11_CEST_2008.bad
>>
>> i've saved the merged 2.6.26-rc8-tip-00241-gc6c8cb2-dirty tree into  
>> tip/tmp.x86.xen-64bit.Sun_Jun_29_10 and pushed it out, so you can test  
>> that exact version.
>
> Looks like the setup.c unification missed the early_ioremap init from 
> the early_ioremap unification.  Unconditionally call 
> early_ioremap_init().

applied to tip/x86/unify-setup - thanks Jeremy.

I've reactived the x86/xen-64bit branch and i'm testing it currently.

	Ingo
