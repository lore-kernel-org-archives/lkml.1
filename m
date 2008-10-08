Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYJHVJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYJHVJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYJHVJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:09:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYJHVJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:09:14 -0400
Date: Wed, 8 Oct 2008 23:08:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yinghai@kernel.org
Subject: Re: [patch 3/7] x86, cpa: make the kernel physical mapping
	initialization a two pass sequence
Message-ID: <20081008210854.GA14309@elte.hu>
References: <20080923210035.413932000@linux-os.sc.intel.com> <20080923211444.369122000@linux-os.sc.intel.com> <48EA798D.1090303@goop.org> <20081007015833.GO15609@linux-os.sc.intel.com> <48EB8008.1020700@goop.org> <20081007205845.GP15609@linux-os.sc.intel.com> <48ED0E22.8080809@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ED0E22.8080809@goop.org>
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

> Suresh Siddha wrote:
>> On Tue, Oct 07, 2008 at 08:28:08AM -0700, Jeremy Fitzhardinge wrote:
>>   
>>> Well, that's OK.  We just need to preserve the original page permissions
>>> when fragmenting the large mappings.  (This isn't a case that affects
>>> Xen, because it will already be 4k mappings.)
>>>     
>>
>> Jeremy, Can you please check if the appended patch fixes your issue and Ack
>> it? Test booted on three different 64bit platforms with and without
>> DEBUG_PAGEALLOC.
>>   
>
> This patch works fine under Xen.  Thanks for the quick fix.
>
> Tested-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/pat, thanks guys!

If it fails testing for some reason then it might not make the first 
v2.6.28 pull request, but it's definitely moving in the right direction 
so the PAT/TLB changes seem v2.6.28 worthy.

	Ingo
