Return-Path: <linux-kernel-owner+w=401wt.eu-S1765248AbXHAMfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765248AbXHAMfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763788AbXHAMfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:35:05 -0400
Received: from neon.samage.net ([85.17.153.66]:33463 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762233AbXHAMfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:35:04 -0400
Message-ID: <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
In-Reply-To: <46B06815.10200@gmail.com>
References: <1185827130.26459.16.camel@xtower.fri>
    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
    <46B06815.10200@gmail.com>
Date: Wed, 1 Aug 2007 14:34:53 +0200 (CEST)
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: "Indan Zupancic" <indan@nul.nu>
To: "Rene Herman" <rene.herman@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "CK Mailinglist" <ck@vds.kolivas.org>, teresa@kvitka.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: a350ae07b5350cdad28cef237d2e7179
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 1, 2007 13:01, Rene Herman wrote:
> On 08/01/2007 01:31 PM, Andi Kleen wrote:
>
>> Ingo Molnar <mingo@elte.hu> writes:
>
>>> another reaction below in this thread reported kbd problems in vanilla
>>> 2.6.22.1 as well. What is the X versions, etc.? Does the problem go away
>>> if the X kbd driver selection is tweaked to a simpler model, say:
>>
>> Or perhaps just test with CFS reverted? It really sounds more like something
>> independent from the scheduler. Perhaps someone could put a CFS-revert-for-testing patch
>> on ftp somewhere. It's only a few git changesets so shouldn't be too difficult to
>> do.
>
> Teresa was already using 2.6.22.1, with CFS (v19.1) patched in, so reverting
> that would be a matter of patching it out again. She said she wasn't seeing
> trouble on other kernels though.
>
> I was the one who also saw keyboard trouble on 2.6.22.1 without CFS by the
> way -- and haven't (yet) seen any anymore since patching _in_ CFS v19.1...

Could the people who had or have keyboard problems try out Dmitry's
input locking patches, and see if those help: http://lkml.org/lkml/2007/7/24/17
And if it does, report it to him, either there or here after CCing him.

Greetings,

Indan


