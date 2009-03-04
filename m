Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZCDSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZCDSDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZCDSDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:03:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38638 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZCDSDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:03:06 -0500
Date: Wed, 4 Mar 2009 19:02:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Maly <bmaly@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] fix DMI for EFI
Message-ID: <20090304180255.GC1537@elte.hu>
References: <49A9F597.4010601@redhat.com> <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com> <49ADEDA3.1030406@redhat.com> <20090304110022.GB18165@elte.hu> <49AE9850.9020103@redhat.com> <20090304175418.GB29823@elte.hu> <49AEC1CA.50405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AEC1CA.50405@redhat.com>
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


* Brian Maly <bmaly@redhat.com> wrote:

>> Your patch looks fine, but i'd like to hear the opinion of 
>> Ying Huang as well.
>
> 	
> I had asked him to look at this before I posted and he had no 
> objections. He may have an opinion on moving dmi scan into 
> efi_init, though this can certainly be done later if and when 
> needed.

No, i think your patch is fine as-is - moving the dmi scan to 
EFI init just makes EFI bootstrap a bit less standard - hence a 
bit more fragile - and that's never good.

Since your patch fixes real issues on Apple hardware i also 
queued it up in tip:x86/urgent for .29-rc8.

	Ingo
