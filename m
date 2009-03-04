Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZCDRys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZCDRys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZCDRyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:54:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbZCDRyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:54:40 -0500
Date: Wed, 4 Mar 2009 18:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Maly <bmaly@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] fix DMI for EFI
Message-ID: <20090304175418.GB29823@elte.hu>
References: <49A9F597.4010601@redhat.com> <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com> <49ADEDA3.1030406@redhat.com> <20090304110022.GB18165@elte.hu> <49AE9850.9020103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AE9850.9020103@redhat.com>
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

>
>
>> Hm, could we ever find ourselves in the positition of having to access 
>> the DMI strings table in the EFI init code, to implement a quirk? I 
>> think that's quite plausible.
>
>> OTOH, with some DMI quirks in EFI tables it's a bit of a chicken and 
>> egg problem. Can DMI strings ever be outside of EFI tables on EFI 
>> systems?
>
>> 	Ingo
>
> Right now it is EFI that loads the dmi tables (and all other 
> tables such as ACPI), so it is a chicken and the egg. I think 
> that if dmi is ever needed by EFI, the dmi scan will have to 
> be moved inside efi_init. We could move the dmi scan into 
> efi_init and do the dmi scan the moment we have the dmi table. 
> Thats really the soonest point we could scan on EFI systems. 
> Im OK with moving dmi to efi_init if you prefer.

Your patch looks fine, but i'd like to hear the opinion of Ying 
Huang as well.

	Ingo
