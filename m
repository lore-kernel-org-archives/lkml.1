Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYL1Ju3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYL1Ju3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL1JuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:50:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYL1JuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:50:20 -0500
Date: Sun, 28 Dec 2008 10:50:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-ID: <20081228095002.GG9022@elte.hu>
References: <patchbomb.1229970362@abulafia.goop.org> <20081227104823.GI14639@elte.hu> <20081228000558I.fujita.tomonori@lab.ntt.co.jp> <4957083B.6090801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4957083B.6090801@goop.org>
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

> FUJITA Tomonori wrote:
>> Well, I asked Jeremy to use Becky's approach so I don't have though
>> this patchset isn't enough for Becky (possibly for Xen too) since
>> Jeremy didn't put Becky's map_single_page changes. These changes are
>> necessary to support map_map_page with highmem. I think that we can do
>> it simpler than his patch. I'll send patches to that in a different
>> way soon.
>>
>> It's not principal objection, but as I said, the patches to revert
>> Jeremy's highmem patches in this patchset like the following are
>> pointless.
>>   
>
> I don't mind either way.  I was hoping to go with something that I've 
> actually tested, but I don't see any reason why Becky's patches won't 
> work in principle for Xen.  I'm on vacation at the moment, but I can 
> test things out when I get back in a couple of weeks and apply whatever 
> fixes are needed at whatever stage we're at then.

yes, obviously we prefer append-only - i kept your patches and added the 
Becky lineup and Fujita's cleanups on top of that. If they break your Xen 
swiotlb use it should all be easily bisectable.

	Ingo
