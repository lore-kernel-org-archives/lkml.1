Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZA0IF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZA0IF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZA0IFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:05:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49002 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZA0IFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:05:19 -0500
Date: Tue, 27 Jan 2009 08:59:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090127075912.GA6551@elte.hu>
References: <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu> <20090121072718.GN24891@wotan.suse.de> <4977A051.8050203@goop.org> <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com> <4978F6C6.3090003@goop.org> <1232664907.16317.182.camel@bodhitayantram.eng.vmware.com> <49790BCC.1040807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49790BCC.1040807@goop.org>
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

>>> Also, I just posted patches to get rid of all pvops calls when 
>>> fetching or setting flags in a pte, which I hope will help.
>>
>> Sounds like it will help.
>
> ...but apparently not.

ping?

This is a very serious paravirt_ops slowdown affecting the native kernel's 
performance to the tune of 5-10% in certain workloads.

It's been about 2 years ago that paravirt_ops went upstream, when you told 
us that something like this would never happen, that paravirt_ops is 
designed so flexibly that it will never hinder the native kernel - and if 
it does it will be easy to fix it. Now is the time to fulfill that 
promise.

	Ingo
