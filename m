Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKFVXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKFVXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYKFVXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:23:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbYKFVXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:23:11 -0500
Date: Thu, 6 Nov 2008 22:22:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       "Christopher S. Aker" <caker@theshore.net>,
       xen devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
Message-ID: <20081106212256.GC24579@elte.hu>
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net> <4910AD00.7040605@theshore.net> <4911BC52.7040905@theshore.net> <1225994697.12607.837.camel@zakaz.uk.xensource.com> <49134257.4000404@goop.org> <20081106211639.GA24579@elte.hu> <49135F84.2060302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49135F84.2060302@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> a "cleanup" impact line is only added if the change is not intended to  
>> have any side-effects whatsoever.
>>
>> We can drop it but it would be really nice to figure out what's going  
>> on. In a very quick late-night look i cannot see anything particularly  
>> weird about it, but based on the type of changes it does there are  
>> three leading candidates: lost high 32 bits, zero extend problem, or  
>> incorrect types.
>
> Yeah, I couldn't see anything either.  It's a reasonable cleanup (I 
> never did understand that struct page * cast), but its always nicer 
> when cleanups don't break working code ;).

Would be nice to have a look at the vmlinux delta with the patch 
reverted, on the .config that breaks. By all means the object code 
should be the same.

	Ingo
